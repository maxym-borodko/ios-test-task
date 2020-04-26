//
//  AlarmViewModel.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 26.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import Foundation


typealias SleepTime = Int

struct AlarmViewModel {

    var state: Observable<String> = Observable<String>("Idle") // get from model
    var sleepTime: Observable<String> = Observable<String>("20 mins") // get from model
    var alarmTime: Observable<String> = Observable<String>("8:30 PM") // get from model
    var actionTitle: Observable<String> = Observable<String>("Play") // get from model
    
    private(set) var sleepTimeValues: [SleepTime] = [0, 1, 5, 10, 15, 20]
    
    private var dateFormatter = DateFormatter()
//    private var model: Any?
    
    init() {
        dateFormatter.dateFormat = "hh:mm a"
    }
    
    mutating func setSleepTimeAt(index: Int) {
        let value = sleepTimeValues[index]
        sleepTime.value = value.stringRepresantative()
        
        // model.sleepTime = value
    }
    
    mutating func setAlarm(dateTime: Date) {
        alarmTime.value = dateFormatter.string(from: dateTime)
        // model.alarmDateTime = dateTime
    }
    
    func changeState() {
        // model.state = !model.state
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
