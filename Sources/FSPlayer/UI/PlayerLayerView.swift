//
//  PlayerLayerView.swift
//  FSPlayer
//
//  Created by Fabiano on 14/09/26.
//

import AVFoundation
import SwiftUI
import UIKit

struct PlayerLayerView: UIViewRepresentable {
    let player: FSPlayer

    func makeUIView(context: Context) -> PlayerContainerView {
        let view = PlayerContainerView()
        view.backgroundColor = .black
        view.playerLayer.player = player.engine.avPlayer
        view.playerLayer.videoGravity = player.videoGravity.avGravity
        return view
    }

    func updateUIView(_ uiView: PlayerContainerView, context: Context) {
        if uiView.playerLayer.player !== player.engine.avPlayer {
            uiView.playerLayer.player = player.engine.avPlayer
        }
        uiView.playerLayer.videoGravity = player.videoGravity.avGravity
    }
}

final class PlayerContainerView: UIView {
    override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }

    var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }
}

extension VideoGravity {
    var avGravity: AVLayerVideoGravity {
        switch self {
        case .resize:
            return .resize
        case .resizeAspect:
            return .resizeAspect
        case .resizeAspectFill:
            return .resizeAspectFill
        }
    }
}
