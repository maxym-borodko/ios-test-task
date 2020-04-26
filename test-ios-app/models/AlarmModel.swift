//
//  AlarmModel.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 26.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class AlarmModel: NSObject {
    
    enum State {
        case idle, playing, sleepPaused, recording, recordingPaused, alarm
        
        func toString() -> String {
            var value = ""
            
            switch self {
            case .idle:
                value = NSLocalizedString("Idle", comment: "")
            case .playing:
                value = NSLocalizedString("Playing", comment: "")
            case .sleepPaused:
                value = NSLocalizedString("Paused", comment: "")
            case .recording:
                value = NSLocalizedString("Recording", comment: "")
            case .recordingPaused:
                value = NSLocalizedString("Recording Paused", comment: "")
            case .alarm:
                value = NSLocalizedString("Alarm", comment: "")
            }
            
            return value
        }
    }
    
    var sleepTime: TimeInterval = 0
    var alarmDate: Date?
    
    private(set) var state: State = .idle
    
    //
    private var timer: Timer?
    
    private var notificationCenter: UNUserNotificationCenter
    private var recordingSession: AVAudioSession?
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    
    override init() {
        notificationCenter = UNUserNotificationCenter.current()
        super.init()
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    //
    func start() {
        self.registerAlarm()
        self.runTimer { _ in
            self.stopAudio()
            self.startRecording()
        }
    }
    
    func pause() {
        if self.state == .playing {
            pauseAudio()
        }
        else if self.state == .recording {
            pauseRecording()
        }
    }
    
    // MARK: - Private methods
    private func registerAlarm() {
        let content = UNMutableNotificationContent()
        content.title = "Weekly Staff Meeting"
        content.body = "Every Tuesday at 2pm"
        
        let comps = Calendar.current.dateComponents(in: Calendar.current.timeZone,
                                                    from: self.alarmDate!)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps,
                                                     repeats: false)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
            }
        }
    }
    
    private func playAudio() {
        self.state = .playing
        if player == nil {
            if let path = Bundle.main.path(forResource: "nature", ofType: "mp4") {
                let url = URL(fileURLWithPath:path)
                
                do {
                    player = try AVAudioPlayer(contentsOf: url)
                    player?.numberOfLoops = -1
                    player?.prepareToPlay()
                }
                catch {
                    
                }
            }
        }
        
        player?.play()
    }
    
    private func runTimer(_ completion: @escaping (Timer) -> Void) {
        self.state = .playing
        self.playAudio()
        
        timer = Timer.scheduledTimer(withTimeInterval: self.sleepTime,
                                     repeats: false,
                                     block: completion)
        
    }
    private func pauseAudio() {
        self.state = .sleepPaused
        player?.pause()
    }
    
    private func stopAudio() {
        self.player?.stop()
        self.player = nil
    }
    
    private func startRecording() {
        self.state = .recording
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.mp4")
        
        do {
            recorder = try AVAudioRecorder(url: audioFilename,
                                           settings: [
                                            AVFormatIDKey: Int(kAudioFormatAppleLossless),
                                            AVSampleRateKey: 44100,
                                            AVNumberOfChannelsKey: 2,
                                            AVEncoderBitRateKey: 320000,
                                            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue])
            
            recorder?.delegate = self
            
            try recordingSession?.setCategory(.record)
            recorder?.record()
        }
        catch {
        }
    }
    
    private func pauseRecording() {
        self.state = .recordingPaused
        self.recorder?.pause()
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}



extension AlarmModel: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
      
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
       
    }
}


extension AlarmModel: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    }
}
