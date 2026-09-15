//
//  PlayerVideoOutput.swift
//  FSPlayer
//
//  Created by Fabiano on 14/09/26.
//

import AVFoundation

protocol PlayerVideoOutput: AnyObject {
    func attach(to layer: AVPlayerLayer)
}
