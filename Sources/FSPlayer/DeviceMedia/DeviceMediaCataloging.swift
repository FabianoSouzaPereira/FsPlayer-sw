//
//  DeviceMediaCataloging.swift
//  FSPlayer
//
//  Created by Fabiano on 15/09/26.
//

import Foundation

protocol DeviceMediaCataloging: AnyObject {
    func items(matching query: String?) async throws -> [DeviceMediaItem]
    func playbackURL(for item: DeviceMediaItem) async throws -> URL
}
