//
//  AlarmModel.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 26.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit



class AlarmModel: NSObject {
    
    static let recordsSuffix = "-record"
    static let soundFile = (name: "nature", format: "mp4")
    static let hoursOffset = 6
    
    enum State {
        case idle, playing, sleepPaused, recording, recordingPaused, alarm
    }
    
    var sleepTime: TimeInterval = 0
    var alarmDateTime: Date
    
    private(set) var state: Observable<State> = Observable<State>(.idle)
    
    private var notificationsModel: NotificationsModel
    private var sleepTimeModel: SleepTimeModel
    private var recordAudioModel: RecordAudioModel
    
    //
    override init() {
        //
        notificationsModel = NotificationsModel()
        sleepTimeModel = SleepTimeModel(audioPath: Bundle.main.path(forResource: AlarmModel.soundFile.name,
                                                                    ofType: AlarmModel.soundFile.format)!)
        recordAudioModel = RecordAudioModel(nameSuffix: AlarmModel.recordsSuffix,
                                            directory: FileManager.default.documentsDirectory())
        alarmDateTime = Calendar.current.date(byAdding: .hour,
                                              value: AlarmModel.hoursOffset,
                                              to: Date())!
        
        super.init()

        setupModels()
    }
    
    //
    func idle() {
        state.value = .idle
    }
    
    func start() {
        switch state.value {
        case .idle, .alarm:
            notificationsModel.registerAlarmWith(alarmDateTime: alarmDateTime)
            sleepTimeModel.runModelWith(sleepTime: sleepTime)
            { [unowned self] in
                self.recordAudioModel.startRecording()
            }
        case .recordingPaused:
            recordAudioModel.startRecording()
        case .sleepPaused:
            sleepTimeModel.playAudio()
        default:
            break
        }
    }
    
    func stop() {
        switch self.state.value {
        case .playing:
            sleepTimeModel.pauseAudio()
        case .recording:
            recordAudioModel.pauseRecording()
        default:
            break
        }
    }
    
    //
    private func setupModels() {
        
        // Error handler
        notificationsModel.errorHandler = self
        recordAudioModel.errorHandler = self
        sleepTimeModel.errorHandler = self
        
        //
        notificationsModel.alarm = { [unowned self] in
            self.recordAudioModel.stopRecording()
            self.state.value = .alarm
        }
        
        //
        sleepTimeModel.isActive.bind { [unowned self] (value) in
            self.updateState()
        }
        
        sleepTimeModel.isPlaying.bind { [unowned self] (value) in
            self.updateState()
        }
        
        //
        recordAudioModel.isActive.bind { [unowned self] (value) in
            self.updateState()
        }
        
        recordAudioModel.isRecording.bind { [unowned self] (value) in
            self.updateState()
        }
    }
    
    private func updateState() {
        if sleepTimeModel.isActive.value {
            state.value = sleepTimeModel.isPlaying.value ? AlarmModel.State.playing : AlarmModel.State.sleepPaused
        }
        else if recordAudioModel.isActive.value {
            state.value = recordAudioModel.isRecording.value ? AlarmModel.State.recording : AlarmModel.State.recordingPaused
        }
        else {
            state.value = .idle
        }
    }
}

extension AlarmModel: ErrorHandler {
    func handle(error: Error) {
        
        // Error handlind strategy of the app needs to be developed with a product manager.
        // Usually, different kinds of alerts, messages, tips or loggers are used in this situations.
        //
        // Now, for simple handling the app just prints the error :)
        //
        print("Error occured: \(error.localizedDescription)")
    }
}
