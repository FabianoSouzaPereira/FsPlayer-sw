//
//  PosterImageView.swift
//  FSPlayer
//
//  Created by Fabiano on 14/09/26.
//

import Kingfisher
import SwiftUI

struct PosterImageView: View {
    let url: URL

    var body: some View {
        GeometryReader { geo in
            KFImage(url)
                .placeholder {
                    Color.black
                }
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
        .allowsHitTesting(false)
    }
}
