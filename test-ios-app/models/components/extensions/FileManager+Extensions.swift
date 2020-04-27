//
//  FileManager+Extensions.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 27.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import Foundation

extension FileManager {
    func documentsDirectory() -> URL {
        let paths = self.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
