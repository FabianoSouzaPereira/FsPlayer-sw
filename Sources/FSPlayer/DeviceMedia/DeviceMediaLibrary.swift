//
//  DeviceMediaLibrary.swift
//  FSPlayer
//
//  Created by Fabiano on 15/09/26.
//

import Foundation

public final class DeviceMediaLibrary {
    private let videos: DeviceMediaCataloging
    private let audio: DeviceMediaCataloging

    public convenience init() {
        self.init(videos: PhotosVideoCatalog(), audio: MusicCatalog())
    }

    init(videos: DeviceMediaCataloging, audio: DeviceMediaCataloging) {
        self.videos = videos
        self.audio = audio
    }

    public func videos(matching query: String? = nil) async throws -> [DeviceMediaItem] {
        try await videos.items(matching: query)
    }

    public func songs(matching query: String? = nil) async throws -> [DeviceMediaItem] {
        try await audio.items(matching: query)
    }

    public func search(_ query: String? = nil) async throws -> [DeviceMediaItem] {
        async let videoItems = videos(matching: query)
        async let songItems = songs(matching: query)
        return try await videoItems + songItems
    }

    public func playerItem(for item: DeviceMediaItem) async throws -> PlayerItem {
        let url: URL
        switch item.source {
        case .resolved(let resolved):
            url = resolved
        case .photoAsset:
            url = try await videos.playbackURL(for: item)
        case .musicItem:
            url = try await audio.playbackURL(for: item)
        }
        return PlayerItem(url: url, title: item.title)
    }
}
