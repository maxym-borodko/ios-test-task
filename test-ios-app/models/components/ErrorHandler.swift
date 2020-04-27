//
//  ErrorHandler.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 27.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import Foundation

protocol ErrorHandler: class {
    func handle(error: Error)
}
