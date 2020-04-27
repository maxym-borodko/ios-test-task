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
        
        func toString() -> String {
            var value = ""
            
            switch self {
            case .idle:
                value = NSLocalizedString("Idle", comment: "")
            case .playing:
                value = NSLocalizedString("Playing", comment: "")
            case .sleepPaused:
                value = NSLocalizedString("Paused", comment: "")
            case .recording:
                value = NSLocalizedString("Recording", comment: "")
            case .recordingPaused:
                value = NSLocalizedString("Recording Paused", comment: "")
            case .alarm:
                value = NSLocalizedString("Alarm", comment: "")
            }
            
            return value
        }
    }
    
    var sleepTime: TimeInterval = 0
    var alarmDateTime: Date
    
    private(set) var state: Observable<State> = Observable<State>(.idle)
    
    private var notificationsModel: NotificationsModel
    private var recordAudioModel: RecordAudioModel
    private var sleepTimeModel: SleepTimeModel
    
    //
    override init() {
        notificationsModel = NotificationsModel()
        
        recordAudioModel = RecordAudioModel(nameSuffix: AlarmModel.recordsSuffix,
                                            directory: FileManager.default.documentsDirectory())
        sleepTimeModel = SleepTimeModel(audioPath: Bundle.main.path(forResource: AlarmModel.soundFile.name,
                                                                    ofType: AlarmModel.soundFile.format)!)
        alarmDateTime = Calendar.current.date(byAdding: .hour,
                                              value: AlarmModel.hoursOffset,
                                              to: Date(),
                                              wrappingComponents: true)!
        
        super.init()
        
        notificationsModel.alarm = { [unowned self] in
            self.state.value = .alarm
            self.recordAudioModel.stopRecording()
        }
    }
    
    //
    func start() {
        switch state.value {
        case .idle, .alarm:
            state.value = .playing
            notificationsModel.registerAlarmWith(alarmDateTime: alarmDateTime)
            sleepTimeModel.runModelWith(sleepTime: sleepTime)
            { [unowned self] in
                self.state.value = .recording
                self.recordAudioModel.startRecording()
            }
        case .recordingPaused:
            state.value = .recording
            recordAudioModel.startRecording()
        case .sleepPaused:
            state.value = .playing
            sleepTimeModel.playAudio()
        default:
            break
        }
    }
    
    func stop() {
        switch self.state.value {
        case .playing:
            state.value = .sleepPaused
            sleepTimeModel.pauseAudio()
        case .recording:
            state.value = .recordingPaused
            recordAudioModel.pauseRecording()
        default:
            break
        }
    }
}
