//
//  ContentView.swift
//  FSPlayer
//
//  Created by Fabiano on 26/05/26.
//

import FSPlayer
import SwiftUI

struct ContentView: View {
    @StateObject private var player = Player()

    var body: some View {
        PlayerView(player: player)
            .ignoresSafeArea()
            .onAppear {
                player.loadQueue([
                    PlayerItem(
                        url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8")!,
                        title: "BipBop",
                        artworkURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg")
                    ),
                    PlayerItem(
                        url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!,
                        title: "BipBop 16x9"
                    )
                ])
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
