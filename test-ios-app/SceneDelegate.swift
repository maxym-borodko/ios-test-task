//
//  SceneDelegate.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 26.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import UIKit
import AVFoundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    static let mainStoryboardName = "Main"
    static let enableNotificationViewControllerIdentifier = "EnableNotificationViewController"
    
    var window: UIWindow?
    lazy var permissionsUtility: PermissionsUtility = {
        let notificationCenter = UNUserNotificationCenter.current()
        let audioSession = AVAudioSession.sharedInstance()
        
        return PermissionsUtility(notificationCenter: notificationCenter,
                                  audioSession: audioSession)
    }()
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        permissionsUtility.permissionsChanged = { [unowned self] (granted) in
            print("permissions changed")
            if let window = self.window {
                self.setRootViewControllerWith(window: window,
                                               isGranted: granted)
            }
        }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        permissionsUtility.checkPermissions()
    }
    
    func setRootViewControllerWith(window: UIWindow, isGranted: Bool) {
        var rootViewController: UIViewController?
        let mainStoryboard = UIStoryboard(name: SceneDelegate.mainStoryboardName,
                                          bundle: nil)
        
        if !isGranted {
            rootViewController = mainStoryboard.instantiateViewController(identifier: SceneDelegate.enableNotificationViewControllerIdentifier)
        }
        else {
            rootViewController = mainStoryboard.instantiateInitialViewController()
        }
        
        window.rootViewController = rootViewController
    }
}

