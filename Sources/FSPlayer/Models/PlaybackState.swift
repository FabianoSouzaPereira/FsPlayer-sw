//
//  PlaybackState.swift
//  FSPlayer
//
//  Created by Fabiano on 14/09/26.
//

import Foundation

public enum PlaybackState: Equatable {
    case idle
    case loading
    case playing
    case paused
    case buffering
    case ended
    case failed(PlayerError)

    public var isPlaying: Bool {
        self == .playing
    }
}
