//
//  PhotosVideoCatalog.swift
//  FSPlayer
//
//  Created by Fabiano on 15/09/26.
//

import AVFoundation
import Foundation
import Photos

final class PhotosVideoCatalog: DeviceMediaCataloging {
    func items(matching query: String?) async throws -> [DeviceMediaItem] {
        try await requestAccess()

        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetch = PHAsset.fetchAssets(with: .video, options: options)

        var items: [DeviceMediaItem] = []
        fetch.enumerateObjects { asset, _, _ in
            let title = Self.title(for: asset)
            if let query, !query.isEmpty, !title.localizedCaseInsensitiveContains(query) {
                return
            }
            items.append(
                DeviceMediaItem(
                    id: asset.localIdentifier,
                    title: title,
                    kind: .video,
                    duration: asset.duration,
                    source: .photoAsset(localIdentifier: asset.localIdentifier)
                )
            )
        }
        return items
    }

    func playbackURL(for item: DeviceMediaItem) async throws -> URL {
        guard case .photoAsset(let localIdentifier) = item.source else {
            throw DeviceMediaError.notFound
        }

        try await requestAccess()

        let fetch = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
        guard let asset = fetch.firstObject else {
            throw DeviceMediaError.notFound
        }

        return try await requestURL(for: asset)
    }

    private func requestAccess() async throws {
        let status = await withCheckedContinuation { continuation in
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                continuation.resume(returning: status)
            }
        }
        switch status {
        case .authorized, .limited:
            return
        default:
            throw DeviceMediaError.photoLibraryDenied
        }
    }

    private func requestURL(for asset: PHAsset) async throws -> URL {
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat

        return try await withCheckedThrowingContinuation { continuation in
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, info in
                if let error = info?[PHImageErrorKey] as? Error {
                    continuation.resume(throwing: DeviceMediaError.failed(error.localizedDescription))
                    return
                }
                if let urlAsset = avAsset as? AVURLAsset {
                    continuation.resume(returning: urlAsset.url)
                    return
                }
                continuation.resume(throwing: DeviceMediaError.notPlayable)
            }
        }
    }

    private static func title(for asset: PHAsset) -> String {
        let filename = PHAssetResource.assetResources(for: asset).first?.originalFilename
        guard let filename, !filename.isEmpty else { return "Video" }
        return (filename as NSString).deletingPathExtension
    }
}
