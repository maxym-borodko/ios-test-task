//
//  EnableNotificationViewController.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 26.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import UIKit

class EnableNotificationViewController: UIViewController {

    // MARK: - Actions
    @IBAction func onOpenSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
