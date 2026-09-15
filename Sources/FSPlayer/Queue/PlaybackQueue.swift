//
//  PlaybackQueue.swift
//  FSPlayer
//
//  Created by Fabiano on 15/09/26.
//

import Combine
import Foundation

public final class PlaybackQueue: ObservableObject {
    @Published public private(set) var items: [PlayerItem] = []
    @Published public private(set) var currentIndex: Int?

    public var currentItem: PlayerItem? {
        guard let currentIndex, items.indices.contains(currentIndex) else { return nil }
        return items[currentIndex]
    }

    public var hasNext: Bool {
        guard let currentIndex else { return false }
        return currentIndex + 1 < items.count
    }

    public var hasPrevious: Bool {
        guard let currentIndex else { return false }
        return currentIndex > 0
    }

    @discardableResult
    func replaceAll(_ items: [PlayerItem], startingAt index: Int = 0) -> PlayerItem? {
        self.items = items
        guard !items.isEmpty else {
            currentIndex = nil
            return nil
        }
        let clamped = min(max(index, 0), items.count - 1)
        currentIndex = clamped
        return items[clamped]
    }

    func append(_ item: PlayerItem) {
        items.append(item)
        if currentIndex == nil {
            currentIndex = 0
        }
    }

    @discardableResult
    func select(_ index: Int) -> PlayerItem? {
        guard items.indices.contains(index) else { return nil }
        currentIndex = index
        return items[index]
    }

    @discardableResult
    func advance() -> PlayerItem? {
        guard hasNext, let currentIndex else { return nil }
        return select(currentIndex + 1)
    }

    @discardableResult
    func retreat() -> PlayerItem? {
        guard hasPrevious, let currentIndex else { return nil }
        return select(currentIndex - 1)
    }
}
