//
//  MusicCatalog.swift
//  FSPlayer
//
//  Created by Fabiano on 15/09/26.
//

import Foundation
import MediaPlayer

final class MusicCatalog: DeviceMediaCataloging {
    func items(matching query: String?) async throws -> [DeviceMediaItem] {
        try await requestAccess()

        let mediaQuery = MPMediaQuery.songs()
        if let query, !query.isEmpty {
            mediaQuery.addFilterPredicate(
                MPMediaPropertyPredicate(
                    value: query,
                    forProperty: MPMediaItemPropertyTitle,
                    comparisonType: .contains
                )
            )
        }

        return (mediaQuery.items ?? []).map { item in
            let title = item.title.flatMap { $0.isEmpty ? nil : $0 } ?? "Song"
            return DeviceMediaItem(
                id: String(item.persistentID),
                title: title,
                kind: .audio,
                duration: item.playbackDuration,
                source: .musicItem(persistentID: item.persistentID, assetURL: item.assetURL)
            )
        }
    }

    func playbackURL(for item: DeviceMediaItem) async throws -> URL {
        guard case .musicItem(_, let assetURL) = item.source else {
            throw DeviceMediaError.notFound
        }
        guard let assetURL else {
            throw DeviceMediaError.notPlayable
        }
        return assetURL
    }

    private func requestAccess() async throws {
        let status = await withCheckedContinuation { continuation in
            MPMediaLibrary.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }
        guard status == .authorized else {
            throw DeviceMediaError.mediaLibraryDenied
        }
    }
}
