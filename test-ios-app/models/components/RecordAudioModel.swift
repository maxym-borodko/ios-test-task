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
    
    static let audioFormatString = "m4a"
    
    //
    weak var errorHandler: ErrorHandler?
    var isRecording: Observable<Bool> = Observable<Bool>(false)
    var isActive: Observable<Bool> = Observable<Bool>(false)
    
    private(set) var nameSuffix: String
    private(set) var directory: URL
    
    private var audioSessionModel: AudioSessionModel?
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
        do {
            if audioSessionModel == nil {
                audioSessionModel = AudioSessionModel()
                isActive.value = true
                try audioSessionModel?.setRecordCategory()
                
                audioSessionModel?.prepareForInterruption = { [unowned self] in
                    let state: AudioSessionModel.State = self.isRecording.value ? .active : .paused
                    self.pauseRecording()
                    
                    return state
                }
                
                audioSessionModel?.restoreAfterInterruption = { [unowned self] (state) in
                    switch state {
                    case .active:
                        self.startRecording()
                    default:
                        self.pauseRecording()
                    }
                }
            }
            
            if recorder == nil {
                
                let pathComponent = sessionsId.description + nameSuffix + "." + RecordAudioModel.audioFormatString
                let audioFilename = directory.appendingPathComponent(pathComponent)
                recorder = try AVAudioRecorder(url: audioFilename,
                                               settings: [
                                                AVFormatIDKey: Int(kAudioFormatAppleLossless),
                                                AVSampleRateKey: 44100,
                                                AVNumberOfChannelsKey: 2,
                                                AVEncoderBitRateKey: 320000,
                                                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue])
                
                recorder?.delegate = self
            }
            
            recorder?.record()
            isRecording.value = true
        }
        catch {
            // The issues here usually occurs because of some problems with audio configs.
            // Would be great to integare a logger to track such kinds of issues.
            errorHandler?.handle(error: error)
        }
    }
    
    func pauseRecording() {
        recorder?.pause()
        isRecording.value = false
    }
    
    func stopRecording() {
        do {
            try audioSessionModel?.setPlaybackCategory()
        }
        catch {
            errorHandler?.handle(error: error)
        }
        
        recorder?.stop()
        isRecording.value = false
        
        recorder = nil
        
        audioSessionModel = nil
        isActive.value = false
        isRecording.value = false
    }
    
    // MARK: - AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        sessionsId += 1
        stopRecording()
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let err = error {
            errorHandler?.handle(error: err)
        }
        
        stopRecording()
    }
}
