//
//  AudioSessionModel.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 27.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import Foundation
import AVFoundation


typealias PrepareForInterruption = () -> AudioSessionModel.State
typealias RestoreAfterInterruption = (AudioSessionModel.State) -> Void

class AudioSessionModel {
    
    enum State {
        case active, paused
    }
    
    var prepareForInterruption: PrepareForInterruption?
    var restoreAfterInterruption: RestoreAfterInterruption?
    
    //
    private(set) var audioSession: AVAudioSession?
    private var notificationCenter = NotificationCenter.default
    
    private var previousState: State?
    
    //
    init() {
        audioSession = AVAudioSession.sharedInstance()
        connectAudioSession()
    }
    
    // MARK: - Public
    func setActive() throws {
        try audioSession?.setActive(true)
    }
    
    func setRecordCategory() throws {
        try audioSession?.setCategory(.record)
    }
    
    func setPlaybackCategory() throws {
        try audioSession?.setCategory(.playback,
                                      mode: .default)
    }
    
    // MARK: - AVAudioSession
    private func connectAudioSession() {
        notificationCenter.addObserver(self,
                                       selector: #selector(interruptedWith(notification:)),
                                       name: AVAudioSession.interruptionNotification,
                                       object: audioSession)
        
    }
    
    private func disconnectAudioSession() {
        notificationCenter.removeObserver(self,
                                          name: AVAudioSession.interruptionNotification,
                                          object: audioSession)
        audioSession = nil
    }
    
    @objc private func interruptedWith(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let interruptiontype = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }
        
        switch interruptiontype {
        case .began:
            if previousState == nil {
                previousState = prepareForInterruption?()
            }
        case .ended:
            // guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            // let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            // options.contains() .shouldResume
            // "Apps that don’t require user input to begin audio playback (such as games) can ignore this flag and resume playback when an interruption ends."
            
            if let state = previousState {
                restoreAfterInterruption?(state)
                previousState = nil
            }
            
        default: ()
        }
    }
    
    //
    deinit {
        disconnectAudioSession()
    }
}
