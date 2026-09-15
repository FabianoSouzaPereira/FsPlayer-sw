//
//  DeviceMediaLibraryTests.swift
//  FSPlayerTests
//
//  Created by Fabiano on 15/09/26.
//

import XCTest
@testable import FSPlayer

final class DeviceMediaLibraryTests: XCTestCase {

    func testSearchCombinesVideosAndSongs() async throws {
        let videos = FakeDeviceMediaCatalog()
        videos.itemsToReturn = [
            DeviceMediaItem(
                id: "v1",
                title: "Holiday",
                kind: .video,
                duration: 12,
                source: .resolved(URL(string: "file://video.mov")!)
            )
        ]
        let songs = FakeDeviceMediaCatalog()
        songs.itemsToReturn = [
            DeviceMediaItem(
                id: "s1",
                title: "Theme",
                kind: .audio,
                duration: 180,
                source: .resolved(URL(string: "file://song.m4a")!)
            )
        ]
        let library = DeviceMediaLibrary(videos: videos, audio: songs)

        let items = try await library.search()

        XCTAssertEqual(items.map(\.id), ["v1", "s1"])
        XCTAssertEqual(items.map(\.kind), [.video, .audio])
    }

    func testVideosMatchingFiltersByTitle() async throws {
        let videos = FakeDeviceMediaCatalog()
        videos.itemsToReturn = [
            DeviceMediaItem(
                id: "v1",
                title: "Beach",
                kind: .video,
                duration: 4,
                source: .resolved(URL(string: "file://beach.mov")!)
            ),
            DeviceMediaItem(
                id: "v2",
                title: "City",
                kind: .video,
                duration: 8,
                source: .resolved(URL(string: "file://city.mov")!)
            )
        ]
        let library = DeviceMediaLibrary(videos: videos, audio: FakeDeviceMediaCatalog())

        let items = try await library.videos(matching: "beach")

        XCTAssertEqual(items.map(\.title), ["Beach"])
    }

    func testPlayerItemUsesResolvedURLAndTitle() async throws {
        let url = URL(string: "file://clip.mov")!
        let item = DeviceMediaItem(
            id: "v1",
            title: "Clip",
            kind: .video,
            duration: 3,
            source: .resolved(url)
        )
        let videos = FakeDeviceMediaCatalog()
        let library = DeviceMediaLibrary(videos: videos, audio: FakeDeviceMediaCatalog())

        let playerItem = try await library.playerItem(for: item)

        XCTAssertEqual(playerItem.url, url)
        XCTAssertEqual(playerItem.title, "Clip")
    }

    func testSongsDeniedSurfacesMediaLibraryError() async {
        let songs = FakeDeviceMediaCatalog()
        songs.error = .mediaLibraryDenied
        let library = DeviceMediaLibrary(videos: FakeDeviceMediaCatalog(), audio: songs)

        do {
            _ = try await library.songs()
            XCTFail("Expected mediaLibraryDenied")
        } catch let error as DeviceMediaError {
            XCTAssertEqual(error, .mediaLibraryDenied)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }
}
