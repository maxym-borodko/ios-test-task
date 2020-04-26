//
//  SceneDelegate.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 26.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    static let mainStoryboardName = "Main"
    static let enableNotificationViewControllerIdentifier = "EnableNotificationViewController"
    
    var lastIsUNGranted: Bool!
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        checkNotificationAuthorizationWith(windowScene: windowScene)
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        checkNotificationAuthorizationWith(windowScene: windowScene)
    }
    
    func checkNotificationAuthorizationWith(windowScene: UIWindowScene) {
        if let window = windowScene.windows.first {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            { (granted, error) in
                
                DispatchQueue.main.async { [unowned self] in
                    if let lastIsUNGranted = self.lastIsUNGranted {
                        if lastIsUNGranted != granted  {
                            self.setRootViewControllerWith(window: window, isUNGranted: granted)
                        }
                    }
                    else {
                        if !granted {
                            self.setRootViewControllerWith(window: window, isUNGranted: granted)
                        }
                    }

                    self.lastIsUNGranted = granted
                }
            }
        }
    }
    
    func setRootViewControllerWith(window: UIWindow, isUNGranted: Bool) {
        var rootViewController: UIViewController?
        let mainStoryboard = UIStoryboard(name: SceneDelegate.mainStoryboardName,
                                          bundle: nil)
        
        if !isUNGranted {
            rootViewController = mainStoryboard.instantiateViewController(identifier: SceneDelegate.enableNotificationViewControllerIdentifier)
        }
        else {
            rootViewController = mainStoryboard.instantiateInitialViewController()
        }
        
        window.rootViewController = rootViewController
    }
}

