//
//  DeviceMediaItem.swift
//  FSPlayer
//
//  Created by Fabiano on 15/09/26.
//

import Foundation

public enum DeviceMediaKind: Equatable {
    case video
    case audio
}

public struct DeviceMediaItem: Equatable, Identifiable {
    public let id: String
    public let title: String
    public let kind: DeviceMediaKind
    public let duration: TimeInterval?

    let source: Source

    enum Source: Equatable {
        case photoAsset(localIdentifier: String)
        case musicItem(persistentID: UInt64, assetURL: URL?)
        case resolved(URL)
    }

    init(
        id: String,
        title: String,
        kind: DeviceMediaKind,
        duration: TimeInterval?,
        source: Source
    ) {
        self.id = id
        self.title = title
        self.kind = kind
        self.duration = duration
        self.source = source
    }
}
