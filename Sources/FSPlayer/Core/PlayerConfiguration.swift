//
//  PlayerConfiguration.swift
//  FSPlayer
//
//  Created by Fabiano on 14/09/26.
//

import Foundation

public enum VideoGravity: Equatable {
    case resize
    case resizeAspect
    case resizeAspectFill
}

public struct PlayerConfiguration: Equatable {
    public var isMuted: Bool
    public var volume: Float
    public var videoGravity: VideoGravity
    public var automaticallyWaitsToMinimizeStalling: Bool
    public var allowsExternalPlayback: Bool
    public var timeUpdateInterval: TimeInterval

    public static let `default` = PlayerConfiguration()

    public init(
        isMuted: Bool = false,
        volume: Float = 1.0,
        videoGravity: VideoGravity = .resizeAspect,
        automaticallyWaitsToMinimizeStalling: Bool = true,
        allowsExternalPlayback: Bool = true,
        timeUpdateInterval: TimeInterval = 0.25
    ) {
        self.isMuted = isMuted
        self.volume = volume
        self.videoGravity = videoGravity
        self.automaticallyWaitsToMinimizeStalling = automaticallyWaitsToMinimizeStalling
        self.allowsExternalPlayback = allowsExternalPlayback
        self.timeUpdateInterval = timeUpdateInterval
    }
}
