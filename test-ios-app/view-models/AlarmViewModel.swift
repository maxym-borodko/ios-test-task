//
//  AlarmViewModel.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 26.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import Foundation


typealias SleepTime = Int

class AlarmViewModel {

    private(set) var state: Observable<String> = Observable<String>("")
    private(set) var sleepTime: Observable<String> = Observable<String>("")
    private(set) var alarmTime: Observable<String> = Observable<String>("")
    private(set) var actionTitle: Observable<String> = Observable<String>("")
    
    private(set) var sleepTimeValues: [SleepTime] = [0, 1, 5, 10, 15, 20]
    
    private var dateFormatter = DateFormatter()
    private var model: AlarmModel = AlarmModel()
    
    init() {
        dateFormatter.dateFormat = "hh:mm a"
        
        model.state.bind({ [unowned self] state in
            
            var action = ""
            switch state {
            case .idle, .sleepPaused, .alarm:
                action = NSLocalizedString("Play", comment: "")
            case .recordingPaused:
                action = NSLocalizedString("Record", comment: "")
            default:
                action = NSLocalizedString("Pause", comment: "")
            }
            
            self.state.value = state.toString()
            self.actionTitle.value = action
        })
        
        setSleepTimeAt(index: 0)
        setAlarm(dateTime: model.alarmDateTime)
    }
    
    func setSleepTimeAt(index: Int) {
        let value = sleepTimeValues[index]
        sleepTime.value = value.stringRepresantative()
        
        model.sleepTime = TimeInterval(value * 60)
    }
    
    func setAlarm(dateTime: Date) {
        alarmTime.value = dateFormatter.string(from: dateTime)
        model.alarmDateTime = dateTime
    }
    
    func changeState() {
        switch model.state.value {
        case .playing, .recording:
            model.stop()
        case .idle, .sleepPaused, .recordingPaused:
            model.start()
        case .alarm:
            model.idle()
            break
        }
    }
}

    
extension SleepTime {
    func stringRepresantative() -> String {
        if self == 0 {
            return NSLocalizedString("Off", comment: "")
        }
        
        return self.description + " " + NSLocalizedString("min", comment: "")
    }
}

extension AlarmModel.State {
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
