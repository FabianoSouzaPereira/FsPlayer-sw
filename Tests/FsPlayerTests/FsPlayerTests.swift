//
//  FSPlayerTests.swift
//  FSPlayerTests
//
//  Created by Fabiano on 26/05/26.
//

import XCTest
@testable import FSPlayer

final class FSPlayerTests: XCTestCase {

    func testPlayerItemStoresURLAndTitle() {
        let url = URL(string: "https://example.com/video.m3u8")!
        let item = PlayerItem(url: url, title: "Demo")

        XCTAssertEqual(item.url, url)
        XCTAssertEqual(item.title, "Demo")
        XCTAssertNil(item.artworkURL)
    }

    func testPlayerItemStoresArtworkURL() {
        let url = URL(string: "https://example.com/video.m3u8")!
        let artwork = URL(string: "https://example.com/poster.jpg")!
        let item = PlayerItem(url: url, title: "Demo", artworkURL: artwork)

        XCTAssertEqual(item.artworkURL, artwork)
    }

    func testPlaybackStateReportsPlaying() {
        XCTAssertTrue(PlaybackState.playing.isPlaying)
        XCTAssertFalse(PlaybackState.paused.isPlaying)
    }

    func testPlayerLoadForwardsItemToEngine() {
        let engine = FakePlayerEngine()
        let item = PlayerItem(url: URL(string: "https://example.com/a.m3u8")!, title: "A")
        let player = Player(engine: engine)

        player.load(item)

        XCTAssertEqual(player.currentItem, item)
        XCTAssertEqual(player.state, .loading)
        XCTAssertEqual(engine.loadedItems, [item])
        XCTAssertTrue(engine.didPrepare)
    }

    func testPlayerPlayPauseAndToggleUseEngine() {
        let engine = FakePlayerEngine()
        let player = Player(engine: engine)

        player.play()
        XCTAssertEqual(engine.playCount, 1)
        XCTAssertEqual(player.state, .playing)

        player.togglePlayPause()
        XCTAssertEqual(engine.pauseCount, 1)
        XCTAssertEqual(player.state, .paused)

        player.togglePlayPause()
        XCTAssertEqual(engine.playCount, 2)
    }

    func testPlayerPlayAfterEndedSeeksToStart() {
        let engine = FakePlayerEngine()
        let player = Player(engine: engine)
        engine.delegate?.engineDidChangeState(.ended)

        player.play()

        XCTAssertEqual(engine.seekTimes, [0])
        XCTAssertEqual(engine.playCount, 1)
    }

    func testPlayerMuteAndVolumeGoThroughEngine() {
        let engine = FakePlayerEngine()
        let configuration = PlayerConfiguration(isMuted: true, volume: 0.4)
        let player = Player(configuration: configuration, engine: engine)

        XCTAssertEqual(engine.appliedConfigurations.last?.isMuted, true)
        XCTAssertEqual(engine.appliedConfigurations.last?.volume, 0.4)

        player.isMuted = false
        player.volume = 2

        XCTAssertFalse(engine.isMuted)
        XCTAssertEqual(engine.volume, 1)
        XCTAssertEqual(player.volume, 1)
    }
}
