//
//  FakeDeviceMediaCatalog.swift
//  FSPlayerTests
//
//  Created by Fabiano on 15/09/26.
//

import Foundation
@testable import FSPlayer

final class FakeDeviceMediaCatalog: DeviceMediaCataloging {
    var itemsToReturn: [DeviceMediaItem] = []
    var urlsByID: [String: URL] = [:]
    var error: DeviceMediaError?

    func items(matching query: String?) async throws -> [DeviceMediaItem] {
        if let error { throw error }
        guard let query, !query.isEmpty else { return itemsToReturn }
        return itemsToReturn.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }

    func playbackURL(for item: DeviceMediaItem) async throws -> URL {
        if let error { throw error }
        if case .resolved(let url) = item.source {
            return url
        }
        guard let url = urlsByID[item.id] else {
            throw DeviceMediaError.notFound
        }
        return url
    }
}
