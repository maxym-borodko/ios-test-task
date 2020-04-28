//
//  SleepTimeModel.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 27.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class SleepTimeModel: AudioModel {

    //
    private var timer: Timer?
    
    // MARK: - Public methods
    func runModelWith(sleepTime: TimeInterval,
                      completion: @escaping () -> Void) {
        if sleepTime == 0 {
            completion()
        }
        else {
            timer = Timer.scheduledTimer(withTimeInterval: sleepTime,
                                         repeats: false,
                                         block: { [unowned self] timer in
                                            self.stopAudio()
                                            completion()
            })
            
            self.playAudio()
        }
    }
    
    override func stopAudio() {
        super.stopAudio()
        timer?.invalidate()
        timer = nil
    }
}
