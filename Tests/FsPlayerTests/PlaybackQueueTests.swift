//
//  PlaybackQueueTests.swift
//  FSPlayerTests
//
//  Created by Fabiano on 15/09/26.
//

import XCTest
@testable import FSPlayer

final class PlaybackQueueTests: XCTestCase {
    private let itemA = PlayerItem(url: URL(string: "https://example.com/a.m3u8")!, title: "A")
    private let itemB = PlayerItem(url: URL(string: "https://example.com/b.m3u8")!, title: "B")
    private let itemC = PlayerItem(url: URL(string: "https://example.com/c.m3u8")!, title: "C")

    func testReplaceAllSelectsStartingIndex() {
        let queue = PlaybackQueue()
        let current = queue.replaceAll([itemA, itemB, itemC], startingAt: 1)

        XCTAssertEqual(current, itemB)
        XCTAssertEqual(queue.currentIndex, 1)
        XCTAssertTrue(queue.hasNext)
        XCTAssertTrue(queue.hasPrevious)
    }

    func testAdvanceAndRetreatMoveCurrentItem() {
        let queue = PlaybackQueue()
        queue.replaceAll([itemA, itemB, itemC])

        XCTAssertEqual(queue.advance(), itemB)
        XCTAssertEqual(queue.advance(), itemC)
        XCTAssertNil(queue.advance())
        XCTAssertEqual(queue.retreat(), itemB)
        XCTAssertEqual(queue.retreat(), itemA)
        XCTAssertNil(queue.retreat())
    }
}

final class PlayerQueueTests: XCTestCase {
    private let itemA = PlayerItem(url: URL(string: "https://example.com/a.m3u8")!, title: "A")
    private let itemB = PlayerItem(url: URL(string: "https://example.com/b.m3u8")!, title: "B")

    func testLoadQueueAndPlayNext() {
        let engine = FakePlayerEngine()
        let player = Player(engine: engine)
        player.loadQueue([itemA, itemB])

        XCTAssertEqual(player.currentItem, itemA)
        XCTAssertEqual(engine.loadedItems, [itemA])

        player.playNext()

        XCTAssertEqual(player.currentItem, itemB)
        XCTAssertEqual(engine.loadedItems, [itemA, itemB])
        XCTAssertEqual(engine.playCount, 1)
    }

    func testEndedAdvancesToNextItem() {
        let engine = FakePlayerEngine()
        let player = Player(engine: engine)
        player.loadQueue([itemA, itemB])

        engine.delegate?.engineDidChangeState(.ended)

        XCTAssertEqual(player.currentItem, itemB)
        XCTAssertEqual(engine.playCount, 1)
    }

    func testPlayPreviousRestartsWhenNearStartOfFirstItem() {
        let engine = FakePlayerEngine()
        let player = Player(engine: engine)
        player.loadQueue([itemA, itemB])
        player.playPrevious()

        XCTAssertEqual(player.currentItem, itemA)
        XCTAssertEqual(engine.seekTimes.last, 0)
    }
}
