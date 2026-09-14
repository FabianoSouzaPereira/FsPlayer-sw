//
//  PlayerView.swift
//  FSPlayer
//
//  Created by Fabiano on 14/09/26.
//

import SwiftUI

public struct PlayerView: View {
    @ObservedObject var player: FSPlayer
    @State private var showsControls: Bool

    private let alwaysShowsControls: Bool

    public init(player: FSPlayer, showsControls: Bool = true) {
        self.player = player
        self._showsControls = State(initialValue: showsControls)
        self.alwaysShowsControls = showsControls
    }

    public var body: some View {
        ZStack {
            PlayerLayerView(player: player)
                .onTapGesture(perform: toggleControls)

            if player.state == .buffering || player.state == .loading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.2)
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

            if showsControls {
                VStack {
                    Spacer()
                    PlayerControlsView(player: player)
                }
            }
        }
        .background(Color.black)
        .onChange(of: player.state) { newState in
            if alwaysShowsControls, newState.isPlaying {
                scheduleControlsHide()
            }
        }
    }

    private func toggleControls() {
        guard alwaysShowsControls else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            showsControls.toggle()
        }
        if showsControls, player.state.isPlaying {
            scheduleControlsHide()
        }
    }

    private func scheduleControlsHide() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            guard player.state.isPlaying, showsControls else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                showsControls = false
            }
        }
    }
}
