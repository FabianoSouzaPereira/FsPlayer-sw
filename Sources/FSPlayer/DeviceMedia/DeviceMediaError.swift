//
//  DeviceMediaError.swift
//  FSPlayer
//
//  Created by Fabiano on 15/09/26.
//

import Foundation

public enum DeviceMediaError: Error, Equatable, LocalizedError {
    case photoLibraryDenied
    case mediaLibraryDenied
    case notFound
    case notPlayable
    case failed(String)

    public var errorDescription: String? {
        switch self {
        case .photoLibraryDenied:
            return "Photo library access was denied."
        case .mediaLibraryDenied:
            return "Media library access was denied."
        case .notFound:
            return "The media item was not found on this device."
        case .notPlayable:
            return "This item cannot be played locally."
        case .failed(let message):
            return message
        }
    }
}
