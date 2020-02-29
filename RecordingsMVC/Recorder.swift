//
//  Recorder.swift
//  RecordingsMVC
//
//  Created by du on 2020/2/29.
//

import UIKit
import AVFoundation

final class Recorder: NSObject {
    
    let url:URL
    private var update: (TimeInterval?) -> ()
    private var timer:Timer?
    private var audioRecorder:AVAudioRecorder?
    
    init?(url:URL, update: @escaping (TimeInterval?) -> ()){
        self.url = url
        self.update = update
        super.init()
     
        do {
            //既可以录音,也可以播放
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
            //
            try AVAudioSession.sharedInstance().setActive(true)
            //请求录音权限
            AVAudioSession.sharedInstance().requestRecordPermission { (allowed) in
                if allowed{
                    self.start(url)
                }
                else{
                    self.update(nil)
                }
            }
        } catch  {
            return nil
        }
    }
    
    private func start(_ url:URL){
        //设置录制格式
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100.0 as Float,
            AVNumberOfChannelsKey: 1
        ]
        
        if let recorder = try? AVAudioRecorder(url: self.url, settings: settings) {
            recorder.delegate = self
            audioRecorder = recorder
            recorder.record()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                self.update(recorder.currentTime)
            })
        }
        else{
            update(nil)
        }
    }
    
     func stop(){
        audioRecorder?.stop()
        timer?.invalidate()
    }
}

extension Recorder:AVAudioRecorderDelegate{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            stop()
        }
        else{
            update(nil)
        }
    }
}
