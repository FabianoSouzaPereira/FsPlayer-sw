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

    @Published public private(set) var state: PlaybackState = .idle
    @Published public private(set) var currentTime: TimeInterval = 0
    @Published public private(set) var duration: TimeInterval = 0
    @Published public private(set) var currentItem: PlayerItem?

    public var isMuted: Bool {
        didSet { engine.avPlayer.isMuted = isMuted }
    }

    public var volume: Float {
        didSet { engine.avPlayer.volume = min(max(volume, 0), 1) }
    }

    public var videoGravity: VideoGravity

    let engine: AVFoundationPlayerEngine

    public init(item: PlayerItem? = nil, configuration: PlayerConfiguration = .default) {
        self.isMuted = configuration.isMuted
        self.volume = configuration.volume
        self.videoGravity = configuration.videoGravity
        self.engine = AVFoundationPlayerEngine(configuration: configuration)
        self.engine.delegate = self
        Self.activateAudioSession()

        if let item {
            load(item)
        }
    }

    public func load(_ item: PlayerItem) {
        currentItem = item
        currentTime = 0
        duration = 0
        state = .loading
        engine.load(item)
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

    public func seek(to time: TimeInterval) {
        let clamped = min(max(time, 0), duration > 0 ? duration : time)
        currentTime = clamped
        engine.seek(to: clamped)
    }

    public func stop() {
        engine.pause()
        engine.seek(to: 0)
        currentTime = 0
        state = .paused
    }

    private static func activateAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .moviePlayback, options: [.allowAirPlay])
            try session.setActive(true)
        } catch {
            // Playback can continue with the system default session.
        }
    }
}

extension Player: PlayerEngineDelegate {
    func engineDidChangeState(_ state: PlaybackState) {
        self.state = state
    }

    func engineDidUpdateTime(current: TimeInterval, duration: TimeInterval) {
        currentTime = current.isFinite ? max(current, 0) : 0
        self.duration = duration
    }
}
