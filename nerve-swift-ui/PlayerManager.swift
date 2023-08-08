//
//  PlayerManager.swift
//  nerve swift ui
//
//  Created by Ryan Xie on 8/8/23.
//

import Foundation
import SwiftUI
import AVKit

class PlayerManager : ObservableObject {
    var player: AVPlayer
    @Published private var playing = false
    
    init(url: URL) {
        player = AVPlayer(url: url)
    }
    
    func play() {
        player.play()
        playing = true
    }
    
    func playPause() {
        if playing {
            player.pause()
        } else {
            player.play()
        }
        playing.toggle()
    }
}
