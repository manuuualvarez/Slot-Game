//
//  PlayingSounds.swift
//  Slot Game
//
//  Created by Manny Alvarez on 25/06/2022.
//

import Foundation
import AVFoundation


var audioPlayer: AVAudioPlayer?


func playSound(sound: String, type: String) {
    if let path = Bundle.main.url(forResource: sound, withExtension: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer?.play()
        } catch {
            print("Could not find and play sound named : \(sound) type: \(type)")
        }
    }
}
