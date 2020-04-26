//
//  SceneDelegate.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 26.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
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
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                    
                    DispatchQueue.main.async {
                        if !granted {
                            let rootViewContoller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "EnableNotificationViewController")
                            window.rootViewController = rootViewContoller
                        }
                    }
            }
            
        }
    }
}

