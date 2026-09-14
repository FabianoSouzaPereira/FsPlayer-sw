//
//  FSPlayerTests.swift
//  FSPlayerTests
//
//  Created by Fabiano on 26/05/26.
//

import XCTest
@testable import FSPlayer

final class FSPlayerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPlayerItemStoresURLAndTitle() {
        let url = URL(string: "https://example.com/video.m3u8")!
        let item = PlayerItem(url: url, title: "Demo")

        XCTAssertEqual(item.url, url)
        XCTAssertEqual(item.title, "Demo")
    }

    func testPlaybackStateReportsPlaying() {
        XCTAssertTrue(PlaybackState.playing.isPlaying)
        XCTAssertFalse(PlaybackState.paused.isPlaying)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
