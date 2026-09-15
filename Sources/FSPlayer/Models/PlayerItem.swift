//
//  PlayerItem.swift
//  FSPlayer
//
//  Created by Fabiano on 14/09/26.
//

import Foundation

public struct PlayerItem: Equatable {
    public let url: URL
    public let title: String?
    public let artworkURL: URL?

    public init(url: URL, title: String? = nil, artworkURL: URL? = nil) {
        self.url = url
        self.title = title
        self.artworkURL = artworkURL
    }
}
