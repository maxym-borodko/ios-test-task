//
//  RecordAudioModel.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 27.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import Foundation
import AVFoundation

class RecordAudioModel: NSObject, AVAudioRecorderDelegate {
    
    private(set) var nameSuffix: String
    private(set) var directory: URL
    
    private var recordingSession: AVAudioSession?
    private var recorder: AVAudioRecorder?
    private var sessionsId: Int = 1
    
    // MARK: - Initializers
    init(nameSuffix: String, directory: URL) {
        self.nameSuffix = nameSuffix
        self.directory = directory
        
        super.init()
    }
    
    // MARK: - Public methods
    func startRecording() {
        let audioFilename = directory.appendingPathComponent(sessionsId.description + nameSuffix + ".m4a")
        recordingSession = AVAudioSession.sharedInstance()
        
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
    
    func pauseRecording() {
        recorder?.pause()
    }
    
    func stopRecording() {
        try? recordingSession?.setCategory(.playback)
        recorder?.stop()
        recorder = nil
    }
    
    // MARK: - AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        sessionsId += 1
        stopRecording()
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        
    }
}
