//
//  SleepTimeModel.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 27.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import Foundation
import AVFoundation

class SleepTimeModel {
    
    static let infiniteNumberOfLoops = -1
    
    //
    private var timer: Timer?
    private var player: AVAudioPlayer?
    
    private var audioPath: String
    
    init(audioPath: String) {
        self.audioPath = audioPath
    }
    
    // MARK: - Public methods
    func runModelWith(sleepTime: TimeInterval,
                      completion: @escaping () -> Void) {
        if sleepTime == 0 {
            completion()
        }
        else {
            timer = Timer.scheduledTimer(withTimeInterval: sleepTime,
                                         repeats: false,
                                         block: { [unowned self] timer in
                                            self.stopAudio()
                                            completion()
            })
            
            self.playAudio()
        }
    }
    
    func playAudio() {
        if player == nil {
            let url = URL(fileURLWithPath: audioPath)
            
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.numberOfLoops = SleepTimeModel.infiniteNumberOfLoops
                player?.prepareToPlay()
            }
            catch {
                
            }
        }
        
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        player?.play()
    }
    
    func pauseAudio() {
        player?.pause()
    }
    
    // MARK: - Private methods
    private func stopAudio() {
        player?.stop()
        player = nil
    }
}
