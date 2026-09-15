//
//  BufferingIndicatorView.swift
//  FSPlayer
//
//  Created by Fabiano on 14/09/26.
//

import Lottie
import SwiftUI

struct BufferingIndicatorView: View {
    var body: some View {
        if let animation {
            LottieView(animation: animation)
                .looping()
                .resizable()
                .frame(width: 72, height: 72)
                .accessibilityLabel("Buffering")
        } else {
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.white)
                .scaleEffect(1.2)
        }
    }

    private var animation: LottieAnimation? {
        LottieAnimation.named("buffering", bundle: .playerResources)
    }
}

private extension Bundle {
    static var playerResources: Bundle {
        let framework = Bundle(for: Player.self)
        if let url = framework.url(forResource: "FSPlayer", withExtension: "bundle"),
           let bundle = Bundle(url: url) {
            return bundle
        }
        return framework
    }
}
