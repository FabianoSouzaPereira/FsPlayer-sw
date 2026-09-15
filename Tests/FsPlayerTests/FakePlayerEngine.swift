//
//  FakePlayerEngine.swift
//  FSPlayerTests
//
//  Created by Fabiano on 15/09/26.
//

import Foundation
@testable import FSPlayer

final class FakePlayerEngine: PlayerEngine {
    weak var delegate: PlayerEngineDelegate?
    var isMuted = false
    var volume: Float = 1

    private(set) var didPrepare = false
    private(set) var loadedItems: [PlayerItem] = []
    private(set) var playCount = 0
    private(set) var pauseCount = 0
    private(set) var seekTimes: [TimeInterval] = []
    private(set) var appliedConfigurations: [PlayerConfiguration] = []

    func prepareForPlayback() {
        didPrepare = true
    }

    func load(_ item: PlayerItem) {
        loadedItems.append(item)
        delegate?.engineDidChangeState(.loading)
    }

    func play() {
        playCount += 1
        delegate?.engineDidChangeState(.playing)
    }

    func pause() {
        pauseCount += 1
        delegate?.engineDidChangeState(.paused)
    }

    func seek(to time: TimeInterval) {
        seekTimes.append(time)
    }

    func apply(_ configuration: PlayerConfiguration) {
        appliedConfigurations.append(configuration)
        isMuted = configuration.isMuted
        volume = configuration.volume
    }
}
