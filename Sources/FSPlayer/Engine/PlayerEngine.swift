//
//  PlayerEngine.swift
//  FSPlayer
//
//  Created by Fabiano on 14/09/26.
//

import Foundation

protocol PlayerEngineDelegate: AnyObject {
    func engineDidChangeState(_ state: PlaybackState)
    func engineDidUpdateTime(current: TimeInterval, duration: TimeInterval)
}

protocol PlayerEngine: AnyObject {
    var delegate: PlayerEngineDelegate? { get set }
    var isMuted: Bool { get set }
    var volume: Float { get set }

    func prepareForPlayback()
    func load(_ item: PlayerItem)
    func play()
    func pause()
    func seek(to time: TimeInterval)
    func apply(_ configuration: PlayerConfiguration)
}
