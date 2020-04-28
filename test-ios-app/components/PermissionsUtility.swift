//
//  PermissionsUtility.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 28.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import Foundation
import UserNotifications
import AVFoundation

typealias PermissionsChangedCallback = (Bool) -> Void

class PermissionsUtility {
    
    //
    let notificationCenter: UNUserNotificationCenter
    let audioSession: AVAudioSession
    
    var permissionsChanged: PermissionsChangedCallback?
    
    //
    private var lastIsGranted: Bool! = true
    
    //
    init(notificationCenter: UNUserNotificationCenter, audioSession: AVAudioSession) {
        self.notificationCenter = notificationCenter
        self.audioSession = audioSession
    }
    
    // MARK: - Public
    func checkPermissions() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
        { [unowned self] (nGranted, error) in
            
                self.audioSession.requestRecordPermission { (rGranted) in
                    self.checkPermissionsStateWithGrantFor(notifications: nGranted,
                                                           recording: rGranted)
                }
        }
    }
    
    // MARK: - Private
    private func checkPermissionsStateWithGrantFor(notifications: Bool, recording: Bool) {
        
        DispatchQueue.main.async { [unowned self] in
            let granted = notifications && recording
            
            if let lastIsUNGranted = self.lastIsGranted {
                if lastIsUNGranted != granted  {
                    self.permissionsChanged?(granted)
                }
            }
            else {
                if !granted {
                    self.permissionsChanged?(granted)
                }
            }
            
            self.lastIsGranted = granted
        }
    }
}
