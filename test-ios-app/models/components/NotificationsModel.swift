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
        
        let comps = Calendar.current.dateComponents(in: Calendar.current.timeZone,
                                                    from: alarmDateTime)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps,
                                                     repeats: false)
        
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
            }
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        alarm?()
    }
    
}
