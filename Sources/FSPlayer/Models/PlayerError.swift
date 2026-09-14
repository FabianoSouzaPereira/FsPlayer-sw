//
//  PlayerError.swift
//  FSPlayer
//
//  Created by Fabiano on 14/09/26.
//

import Foundation

public enum PlayerError: Error, Equatable, LocalizedError {
    case invalidURL
    case itemFailed(String)
    case unknown

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The media URL is invalid."
        case .itemFailed(let message):
            return message
        case .unknown:
            return "An unknown playback error occurred."
        }
    }
}
