//
//  SleepTimeModel.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 27.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class SleepTimeModel {
    
    static let infiniteNumberOfLoops = -1
    
    //
    weak var errorHandler: ErrorHandler?
    
    //
    private var timer: Timer?
    private var player: AVAudioPlayer?
    private var audioSession: AVAudioSession?
    
    private var audioPath: String
    
    init(audioPath: String) {
        self.audioPath = audioPath
        self.audioSession = AVAudioSession.sharedInstance()
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
        do {
            if player == nil {
                let url = URL(fileURLWithPath: audioPath)
                player = try AVAudioPlayer(contentsOf: url)
            }
            
            player?.numberOfLoops = SleepTimeModel.infiniteNumberOfLoops
            player?.prepareToPlay()
            
            try audioSession?.setCategory(.playback)
            player?.play()
        }
        catch {
            // usually, errors in this case are related with broken or missed
            // resources or some OS issues, that can't be fixed with user's help.
            // We need to integrate an additional logger to track such issues
            errorHandler?.handle(error: error)
        }
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
