//
//  NowPlayingSession.swift
//  FSPlayer
//
//  Created by Fabiano on 15/09/26.
//

import Combine
import Foundation
import MediaPlayer
import UIKit

final class NowPlayingSession {
    private weak var player: Player?
    private var cancellables = Set<AnyCancellable>()

    func start(player: Player) {
        self.player = player
        UIApplication.shared.beginReceivingRemoteControlEvents()
        registerCommands()
        bind(player)
        publish()
    }

    func stop() {
        cancellables.removeAll()
        let center = MPRemoteCommandCenter.shared()
        center.playCommand.removeTarget(nil)
        center.pauseCommand.removeTarget(nil)
        center.togglePlayPauseCommand.removeTarget(nil)
        center.nextTrackCommand.removeTarget(nil)
        center.previousTrackCommand.removeTarget(nil)
        center.changePlaybackPositionCommand.removeTarget(nil)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        player = nil
    }

    func activate() {
        registerCommands()
        publish()
    }

    func publish() {
        guard let player else { return }

        var info: [String: Any] = [
            MPMediaItemPropertyTitle: player.currentItem?.title ?? "FSPlayer",
            MPNowPlayingInfoPropertyElapsedPlaybackTime: player.currentTime,
            MPMediaItemPropertyPlaybackDuration: player.duration,
            MPNowPlayingInfoPropertyPlaybackRate: player.state.isPlaying ? 1.0 : 0.0,
            MPNowPlayingInfoPropertyDefaultPlaybackRate: 1.0
        ]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info

        let center = MPRemoteCommandCenter.shared()
        center.nextTrackCommand.isEnabled = player.queue.hasNext
        center.previousTrackCommand.isEnabled = player.queue.hasPrevious || player.currentTime > 0
    }

    private func bind(_ player: Player) {
        cancellables.removeAll()
        player.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.publish()
            }
            .store(in: &cancellables)
    }

    private func registerCommands() {
        let center = MPRemoteCommandCenter.shared()
        center.playCommand.removeTarget(nil)
        center.pauseCommand.removeTarget(nil)
        center.togglePlayPauseCommand.removeTarget(nil)
        center.nextTrackCommand.removeTarget(nil)
        center.previousTrackCommand.removeTarget(nil)
        center.changePlaybackPositionCommand.removeTarget(nil)

        center.playCommand.addTarget { [weak self] _ in
            self?.player?.play()
            return .success
        }
        center.pauseCommand.addTarget { [weak self] _ in
            self?.player?.pause()
            return .success
        }
        center.togglePlayPauseCommand.addTarget { [weak self] _ in
            self?.player?.togglePlayPause()
            return .success
        }
        center.nextTrackCommand.addTarget { [weak self] _ in
            self?.player?.playNext()
            return .success
        }
        center.previousTrackCommand.addTarget { [weak self] _ in
            self?.player?.playPrevious()
            return .success
        }
        center.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let event = event as? MPChangePlaybackPositionCommandEvent else {
                return .commandFailed
            }
            self?.player?.seek(to: event.positionTime)
            return .success
        }
    }
}
