//
//  PlayerView.swift
//  FSPlayer
//
//  Created by Fabiano on 14/09/26.
//

import SwiftUI

public struct PlayerView: View {
    @ObservedObject var player: Player
    @State private var showsControls: Bool
    @State private var showsQueue = false

    private let alwaysShowsControls: Bool

    public init(player: Player, showsControls: Bool = true) {
        self.player = player
        self._showsControls = State(initialValue: showsControls)
        self.alwaysShowsControls = showsControls
    }

    public var body: some View {
        ZStack {
            PlayerLayerView(player: player)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay {
                    if showsPoster, let artworkURL = player.currentItem?.artworkURL {
                        PosterImageView(url: artworkURL)
                    }
                }
                .onTapGesture(perform: toggleControls)

            if player.state == .buffering || player.state == .loading {
                BufferingIndicatorView()
            }

            if case .failed(let error) = player.state {
                Text(error.localizedDescription)
                    .font(.footnote)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding()
            }

            VStack {
                Spacer()
                if showsQueue {
                    PlaybackQueueView(player: player) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showsQueue = false
                        }
                    }
                }
                if showsControls {
                    PlayerControlsView(
                        player: player,
                        onQueueTap: toggleQueue,
                        onNowPlayingTap: activateNowPlaying
                    )
                }
            }
        }
        .background(Color.black)
        .onChange(of: player.state) { newState in
            if alwaysShowsControls, newState.isPlaying, !showsQueue {
                scheduleControlsHide()
            }
        }
    }

    private var showsPoster: Bool {
        guard player.currentItem?.artworkURL != nil else { return false }
        switch player.state {
        case .idle, .loading:
            return true
        case .paused:
            return player.currentTime <= 0
        default:
            return false
        }
    }

    private func toggleQueue() {
        withAnimation(.easeInOut(duration: 0.2)) {
            showsQueue.toggle()
            if showsQueue {
                showsControls = true
            }
        }
    }

    private func activateNowPlaying() {
        player.activateNowPlaying()
        withAnimation(.easeInOut(duration: 0.2)) {
            showsControls = true
        }
    }

    private func toggleControls() {
        guard alwaysShowsControls else { return }
        if showsQueue {
            withAnimation(.easeInOut(duration: 0.2)) {
                showsQueue = false
            }
            return
        }
        withAnimation(.easeInOut(duration: 0.2)) {
            showsControls.toggle()
        }
        if showsControls, player.state.isPlaying {
            scheduleControlsHide()
        }
    }

    private func scheduleControlsHide() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            guard player.state.isPlaying, showsControls, !showsQueue else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                showsControls = false
            }
        }
    }
}
