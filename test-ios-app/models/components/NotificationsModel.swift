//
//  NotificationsModel.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 27.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import Foundation
import UIKit


typealias AlarmCompletion = () -> Void

class NotificationsModel: NSObject, UNUserNotificationCenterDelegate {
    
    var alarm: AlarmCompletion?
    
    weak var errorHandler: ErrorHandler?
    
    private var notificationCenter: UNUserNotificationCenter
    
    // MARK: - Initializers
    override init() {
        notificationCenter = UNUserNotificationCenter.current()
        super.init()
        
        notificationCenter.delegate = self
    }
    
    // MARK: - Public methods
    func registerAlarmWith(alarmDateTime: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: alarmDateTime.timeIntervalSince(Date()),
                                                        repeats: false)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request) { [unowned self] (error) in
            if let err = error {
                self.errorHandler?.handle(error: err)
            }
        }
        
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // handle
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        alarm?()
    }
    
}
