//
//  PlaybackQueueView.swift
//  FSPlayer
//
//  Created by Fabiano on 15/09/26.
//

import SwiftUI

struct PlaybackQueueView: View {
    @ObservedObject var player: Player
    var onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Queue")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Button("Close", action: onClose)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                    .accessibilityLabel("Close queue")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            if player.queue.items.isEmpty {
                Text("No items in the queue")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(player.queue.items.enumerated()), id: \.offset) { index, item in
                            Button {
                                player.playItem(at: index)
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: index == player.queue.currentIndex ? "speaker.wave.2.fill" : "text.quote")
                                        .foregroundColor(.white)
                                        .frame(width: 22)
                                    Text(item.title ?? "Item \(index + 1)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    index == player.queue.currentIndex
                                        ? Color.white.opacity(0.12)
                                        : Color.clear
                                )
                            }
                            .accessibilityLabel(item.title ?? "Queue item \(index + 1)")
                        }
                    }
                }
                .frame(maxHeight: 220)
            }
        }
        .background(Color.black.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
    }
}
