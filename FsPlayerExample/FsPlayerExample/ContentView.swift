//
//  ContentView.swift
//  FSPlayer
//
//  Created by Fabiano on 26/05/26.
//

import FSPlayer
import SwiftUI

struct ContentView: View {
    @StateObject private var player = FSPlayer(
        item: PlayerItem(
            url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8")!,
            title: "BipBop"
        )
    )

    var body: some View {
        PlayerView(player: player)
            .ignoresSafeArea()
            .onAppear {
                player.play()
            }
            .onDisappear {
                player.pause()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
