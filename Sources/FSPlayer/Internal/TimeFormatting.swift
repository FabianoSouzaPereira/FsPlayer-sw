//
//  TimeFormatting.swift
//  FSPlayer
//
//  Created by Fabiano on 14/09/26.
//

import Foundation

enum TimeFormatting {
    static func string(from time: TimeInterval) -> String {
        guard time.isFinite, time >= 0 else { return "--:--" }

        let totalSeconds = Int(time.rounded(.down))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }

        return String(format: "%02d:%02d", minutes, seconds)
    }
}
