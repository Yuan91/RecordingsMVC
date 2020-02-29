//
//  Player.swift
//  RecordingsMVC
//
//  Created by du on 2020/2/29.
//

import UIKit
import AVFoundation

class Player: NSObject {
    var timer: Timer?
    var update: (TimeInterval?) -> ()
    var audioPlayer: AVAudioPlayer
    
    init?(url: URL, update: @escaping (TimeInterval?) -> ()) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch  {
            return nil
        }
        
        
        guard let player = try? AVAudioPlayer(contentsOf: url) else { return nil }
        audioPlayer = player
        
        //注意以下三行代码的顺序,不能错乱
        //当前类的属性,必须在调用super.init 之前完成初始化
        self.update = update
        //调用super.init 保证父类以及其他继承来的属性能够正确的初始化
        super.init()
        //初始化过程完成之前,不能使用self,所以这行代码必须放在super.init 之前
        audioPlayer.delegate = self
    }
    
    var duration:TimeInterval{
        audioPlayer.duration
    }
    
    var isPlaying: Bool {
        return audioPlayer.isPlaying
    }
    
    var isPaused: Bool {
        return !audioPlayer.isPlaying && audioPlayer.currentTime > 0
    }
    
    func start()  {
        if audioPlayer.isPlaying {
            stop()
        }
        else {
            audioPlayer.play()
            if let t = timer {
                t.invalidate()
            }
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { [weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.update(weakSelf.audioPlayer.currentTime)
            })
        }
    }
    
    func setProgress(_ time:TimeInterval) {
        audioPlayer.currentTime = time
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        audioPlayer.pause()
    }
    
    deinit {
        timer?.invalidate()
    }
}

extension Player: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            stop()
            update(flag ? player.currentTime : nil)
        }
    }
}
