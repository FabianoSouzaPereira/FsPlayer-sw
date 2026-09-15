//
//  PlayerControlsView.swift
//  FSPlayer
//
//  Created by Fabiano on 14/09/26.
//

import SwiftUI

public struct PlayerControlsView: View {
    @ObservedObject var player: Player
    @State private var isScrubbing = false
    @State private var scrubTime: TimeInterval = 0

    public init(player: Player) {
        self.player = player
    }

    public var body: some View {
        VStack(spacing: 12) {
            if let title = player.currentItem?.title {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            HStack(spacing: 16) {
                Button(action: player.togglePlayPause) {
                    Image(systemName: playPauseSymbol)
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel(player.state.isPlaying ? "Pause" : "Play")

                Text(TimeFormatting.string(from: displayedTime))
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.white)
                    .frame(width: 52, alignment: .leading)

                Slider(
                    value: Binding(
                        get: { displayedTime },
                        set: { scrubTime = $0 }
                    ),
                    in: 0...sliderUpperBound,
                    onEditingChanged: handleScrubbing
                )
                .disabled(player.duration <= 0)
                .tint(.white)

                Text(TimeFormatting.string(from: player.duration))
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.white)
                    .frame(width: 52, alignment: .trailing)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                colors: [.clear, Color.black.opacity(0.75)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    private var playPauseSymbol: String {
        switch player.state {
        case .playing, .buffering:
            return "pause.fill"
        case .ended:
            return "gobackward"
        default:
            return "play.fill"
        }
    }

    private var displayedTime: TimeInterval {
        isScrubbing ? scrubTime : player.currentTime
    }

    private var sliderUpperBound: TimeInterval {
        max(player.duration, 0.01)
    }

    private func handleScrubbing(_ editing: Bool) {
        isScrubbing = editing
        if editing {
            scrubTime = player.currentTime
        } else {
            player.seek(to: scrubTime)
        }
    }
}
