//
//  Player.swift
//  FSPlayer
//
//  Created by Fabiano on 14/09/26.
//

import AVFoundation
import Combine
import Foundation

public final class Player: ObservableObject {
    public static let version = "0.1.0"
    private static let replayPreviousThreshold: TimeInterval = 3

    @Published public private(set) var state: PlaybackState = .idle
    @Published public private(set) var currentTime: TimeInterval = 0
    @Published public private(set) var duration: TimeInterval = 0
    @Published public private(set) var currentItem: PlayerItem?

    public let queue = PlaybackQueue()

    public var isMuted: Bool {
        didSet { engine.isMuted = isMuted }
    }

    public var volume: Float {
        didSet {
            let clamped = min(max(volume, 0), 1)
            if volume != clamped {
                volume = clamped
            }
            engine.volume = clamped
        }
    }

    public var videoGravity: VideoGravity

    private let engine: PlayerEngine
    private let nowPlaying: NowPlayingSession?
    private var queueObservation: AnyCancellable?

    public convenience init(item: PlayerItem? = nil, configuration: PlayerConfiguration = .default) {
        self.init(
            item: item,
            configuration: configuration,
            engine: AVFoundationPlayerEngine(configuration: configuration),
            enablesNowPlaying: true
        )
    }

    init(
        item: PlayerItem? = nil,
        configuration: PlayerConfiguration = .default,
        engine: PlayerEngine,
        enablesNowPlaying: Bool = false
    ) {
        self.isMuted = configuration.isMuted
        self.volume = configuration.volume
        self.videoGravity = configuration.videoGravity
        self.engine = engine
        self.nowPlaying = enablesNowPlaying ? NowPlayingSession() : nil
        self.engine.delegate = self
        self.engine.apply(configuration)
        self.engine.prepareForPlayback()
        queueObservation = queue.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }

        if let item {
            queue.replaceAll([item])
            loadCurrent(play: false)
        }

        if enablesNowPlaying {
            nowPlaying?.start(player: self)
        }
    }

    deinit {
        nowPlaying?.stop()
    }

    public func load(_ item: PlayerItem) {
        queue.replaceAll([item])
        loadCurrent(play: false)
    }

    public func loadQueue(_ items: [PlayerItem], startingAt index: Int = 0) {
        queue.replaceAll(items, startingAt: index)
        loadCurrent(play: false)
    }

    public func enqueue(_ item: PlayerItem) {
        queue.append(item)
        if currentItem == nil {
            loadCurrent(play: false)
        }
    }

    public func play() {
        if state == .ended {
            engine.seek(to: 0)
        }
        engine.play()
    }

    public func pause() {
        engine.pause()
    }

    public func togglePlayPause() {
        if state.isPlaying {
            pause()
        } else {
            play()
        }
    }

    public func playNext() {
        guard queue.advance() != nil else { return }
        loadCurrent(play: true)
    }

    public func playPrevious() {
        if currentTime > Self.replayPreviousThreshold || !queue.hasPrevious {
            seek(to: 0)
            play()
            return
        }
        guard queue.retreat() != nil else { return }
        loadCurrent(play: true)
    }

    public func playItem(at index: Int) {
        guard queue.select(index) != nil else { return }
        loadCurrent(play: true)
    }

    public func seek(to time: TimeInterval) {
        let clamped = min(max(time, 0), duration > 0 ? duration : time)
        currentTime = clamped
        engine.seek(to: clamped)
        nowPlaying?.publish()
    }

    public func stop() {
        engine.pause()
        engine.seek(to: 0)
        currentTime = 0
        state = .paused
        nowPlaying?.publish()
    }

    public func activateNowPlaying() {
        nowPlaying?.activate()
    }

    func attachVideo(to layer: AVPlayerLayer) {
        (engine as? PlayerVideoOutput)?.attach(to: layer)
    }

    private func loadCurrent(play shouldPlay: Bool) {
        guard let item = queue.currentItem else {
            currentItem = nil
            currentTime = 0
            duration = 0
            state = .idle
            engine.pause()
            nowPlaying?.publish()
            return
        }

        currentItem = item
        currentTime = 0
        duration = 0
        state = .loading
        engine.load(item)
        if shouldPlay {
            engine.play()
        }
        nowPlaying?.publish()
    }
}

extension Player: PlayerEngineDelegate {
    func engineDidChangeState(_ state: PlaybackState) {
        if state == .ended, queue.hasNext {
            playNext()
            return
        }
        self.state = state
        nowPlaying?.publish()
    }

    func engineDidUpdateTime(current: TimeInterval, duration: TimeInterval) {
        currentTime = current.isFinite ? max(current, 0) : 0
        self.duration = duration
        nowPlaying?.publish()
    }
}
