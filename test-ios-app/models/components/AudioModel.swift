//
//  AudioModel.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 28.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import Foundation
import AVFoundation

class AudioModel {
    
    static let infiniteNumberOfLoops = -1
    
    //
    weak var errorHandler: ErrorHandler?
    private(set) var isPlaying: Observable<Bool> = Observable<Bool>(false)
    private(set) var isActive: Observable<Bool> = Observable<Bool>(false)
    
    //
    private var player: AVAudioPlayer?
    private var audioSessionModel: AudioSessionModel?
    
    private var audioPath: String
    
    init(audioPath: String) {
        self.audioPath = audioPath
    }
    
    // MARK: - Public methods
    func playAudio() {
        do {
            //
            if audioSessionModel == nil {
                audioSessionModel = AudioSessionModel()
                audioSessionModel?.prepareForInterruption = { [unowned self] in
                    let state: AudioSessionModel.State = self.isPlaying.value ? .active : .paused
                    self.pauseAudio()
                    
                    return state
                }
                
                audioSessionModel?.restoreAfterInterruption = { [unowned self] (state) in
                    switch state {
                    case .active:
                        self.playAudio()
                    default:
                        self.pauseAudio()
                    }
                }
                
                isActive.value = true
            }
            //
            if player == nil {
                let url = URL(fileURLWithPath: audioPath)
                player = try AVAudioPlayer(contentsOf: url)
                
                player?.numberOfLoops = SleepTimeModel.infiniteNumberOfLoops
                player?.prepareToPlay()

                try audioSessionModel?.setActive()
                try audioSessionModel?.setPlaybackCategory()
            }
            
            player?.play()
            isPlaying.value = true
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
        isPlaying.value = false
    }
    
    func stopAudio() {
        player?.stop()
        isPlaying.value = false
        player = nil
        audioSessionModel = nil
        isActive.value = false
    }
}

