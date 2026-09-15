//
//  PlayerControlsView.swift
//  FSPlayer
//
//  Created by Fabiano on 14/09/26.
//

import SwiftUI

public struct PlayerControlsView: View {
    @ObservedObject var player: Player
    var onQueueTap: () -> Void
    var onNowPlayingTap: () -> Void

    @State private var isScrubbing = false
    @State private var scrubTime: TimeInterval = 0

    public init(
        player: Player,
        onQueueTap: @escaping () -> Void = {},
        onNowPlayingTap: @escaping () -> Void = {}
    ) {
        self.player = player
        self.onQueueTap = onQueueTap
        self.onNowPlayingTap = onNowPlayingTap
    }

    public var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                Button(action: onQueueTap) {
                    HStack(spacing: 6) {
                        Text(player.currentItem?.title ?? "Queue")
                            .font(.headline)
                            .lineLimit(1)
                        Image(systemName: "list.bullet")
                            .font(.subheadline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .accessibilityLabel("Queue")

                Button("Now Playing", action: onNowPlayingTap)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                    .accessibilityLabel("Now Playing")
            }

            HStack(spacing: 20) {
                Button(action: player.playPrevious) {
                    Image(systemName: "backward.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 36, height: 44)
                }
                .accessibilityLabel("Previous")

                Button(action: player.togglePlayPause) {
                    Image(systemName: playPauseSymbol)
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel(player.state.isPlaying ? "Pause" : "Play")

                Button(action: player.playNext) {
                    Image(systemName: "forward.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 36, height: 44)
                }
                .disabled(!player.queue.hasNext)
                .opacity(player.queue.hasNext ? 1 : 0.35)
                .accessibilityLabel("Next")
            }
            .frame(maxWidth: .infinity)

            HStack(spacing: 10) {
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
                .frame(minWidth: 80, maxWidth: .infinity)

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
