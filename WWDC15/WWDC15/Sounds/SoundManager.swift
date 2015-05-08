//
//  SoundManager.swift
//  WWDC15
//
//  Created by Yichen Cao on 4/26/15.
//  Copyright (c) 2015 Schemetrical. All rights reserved.
//

import UIKit
import AVFoundation

private let _SoundManagerSharedInstance = SoundManager()

class SoundManager: NSObject, AVAudioPlayerDelegate {
    static let sharedInstance = SoundManager()
    
    var audioPlayers = NSMutableArray()
    
    func soundNotes(sound: Int) {
        if sound < 10 {
            for soundIndex in 0...sound {
                let soundPath = NSBundle.mainBundle().URLForResource("sound\(soundIndex).aiff", withExtension: nil)!
                self.playNote(URL: soundPath)
            }
        }
    }
    
    func playNote(#URL:NSURL) {
        var audioPlayer = AVAudioPlayer(contentsOfURL: URL, error: nil)
        audioPlayer.delegate = self
        self.audioPlayers.addObject(audioPlayer)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        self.audioPlayers.removeObject(player)
    }
}
