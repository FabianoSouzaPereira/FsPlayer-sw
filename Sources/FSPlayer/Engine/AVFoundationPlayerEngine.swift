//
//  AVFoundationPlayerEngine.swift
//  FSPlayer
//
//  Created by Fabiano on 14/09/26.
//

import AVFoundation
import Foundation

final class AVFoundationPlayerEngine: PlayerEngine, PlayerVideoOutput {
    weak var delegate: PlayerEngineDelegate?

    var isMuted: Bool {
        get { avPlayer.isMuted }
        set { avPlayer.isMuted = newValue }
    }

    var volume: Float {
        get { avPlayer.volume }
        set { avPlayer.volume = min(max(newValue, 0), 1) }
    }

    private let avPlayer = AVPlayer()
    private var timeObserver: Any?
    private var observations: [NSKeyValueObservation] = []
    private var endObserver: NSObjectProtocol?
    private var failedObserver: NSObjectProtocol?

    init(configuration: PlayerConfiguration) {
        apply(configuration)
    }

    func prepareForPlayback() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .moviePlayback, options: [.allowAirPlay])
            try session.setActive(true)
        } catch {
            // Playback can continue with the system default session.
        }
    }

    func attach(to layer: AVPlayerLayer) {
        if layer.player !== avPlayer {
            layer.player = avPlayer
        }
    }

    deinit {
        if let timeObserver {
            avPlayer.removeTimeObserver(timeObserver)
        }
        removeObservers()
    }

    func load(_ item: PlayerItem) {
        removeObservers()
        let playerItem = AVPlayerItem(url: item.url)
        avPlayer.replaceCurrentItem(with: playerItem)
        addObservers(for: playerItem)
        delegate?.engineDidChangeState(.loading)
    }

    func play() {
        avPlayer.play()
    }

    func pause() {
        avPlayer.pause()
    }

    func seek(to time: TimeInterval) {
        let cmTime = CMTime(seconds: max(time, 0), preferredTimescale: 600)
        avPlayer.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }

    func apply(_ configuration: PlayerConfiguration) {
        avPlayer.isMuted = configuration.isMuted
        avPlayer.volume = configuration.volume
        avPlayer.automaticallyWaitsToMinimizeStalling = configuration.automaticallyWaitsToMinimizeStalling
        avPlayer.allowsExternalPlayback = configuration.allowsExternalPlayback
        replaceTimeObserver(interval: configuration.timeUpdateInterval)
    }

    private func replaceTimeObserver(interval: TimeInterval) {
        if let timeObserver {
            avPlayer.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }

        let cmInterval = CMTime(seconds: max(interval, 0.1), preferredTimescale: 600)
        timeObserver = avPlayer.addPeriodicTimeObserver(
            forInterval: cmInterval,
            queue: .main
        ) { [weak self] time in
            guard let self else { return }
            self.delegate?.engineDidUpdateTime(
                current: time.seconds,
                duration: self.currentDuration
            )
        }
    }

    private var currentDuration: TimeInterval {
        guard let item = avPlayer.currentItem else { return 0 }
        let seconds = item.duration.seconds
        return seconds.isFinite ? max(seconds, 0) : 0
    }

    private func addObservers(for item: AVPlayerItem) {
        observations = [
            item.observe(\.status, options: [.initial, .new]) { [weak self] playerItem, _ in
                self?.handleStatusChange(playerItem.status, error: playerItem.error)
            },
            avPlayer.observe(\.timeControlStatus, options: [.initial, .new]) { [weak self] player, _ in
                self?.handleTimeControlStatus(player.timeControlStatus)
            }
        ]

        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] _ in
            self?.delegate?.engineDidChangeState(.ended)
        }

        failedObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemFailedToPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] notification in
            let message = (notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error)?.localizedDescription
            self?.delegate?.engineDidChangeState(.failed(.itemFailed(message ?? "Playback failed.")))
        }
    }

    private func handleStatusChange(_ status: AVPlayerItem.Status, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            switch status {
            case .readyToPlay:
                self?.handleTimeControlStatus(self?.avPlayer.timeControlStatus ?? .paused)
            case .failed:
                let message = error?.localizedDescription ?? "Unable to load the media item."
                self?.delegate?.engineDidChangeState(.failed(.itemFailed(message)))
            case .unknown:
                self?.delegate?.engineDidChangeState(.loading)
            @unknown default:
                self?.delegate?.engineDidChangeState(.loading)
            }
        }
    }

    private func handleTimeControlStatus(_ status: AVPlayer.TimeControlStatus) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if self.avPlayer.currentItem?.status == .failed { return }

            switch status {
            case .playing:
                self.delegate?.engineDidChangeState(.playing)
            case .paused:
                if self.avPlayer.currentItem?.status == .readyToPlay {
                    self.delegate?.engineDidChangeState(.paused)
                }
            case .waitingToPlayAtSpecifiedRate:
                self.delegate?.engineDidChangeState(.buffering)
            @unknown default:
                break
            }
        }
    }

    private func removeObservers() {
        observations.forEach { $0.invalidate() }
        observations.removeAll()

        if let endObserver {
            NotificationCenter.default.removeObserver(endObserver)
            self.endObserver = nil
        }

        if let failedObserver {
            NotificationCenter.default.removeObserver(failedObserver)
            self.failedObserver = nil
        }
    }
}
