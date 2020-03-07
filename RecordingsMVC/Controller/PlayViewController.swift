//
//  PlayViewController.swift
//  RecordingsMVC
//
//  Created by du on 2020/2/12.
//

import UIKit

class PlayViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var noRecordingLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    var audioPlayer: Player?
    var recording: Recording?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        setNoRecordStatus(showOrHidden: false)
        setPlayerStatus(showOrHidden: false)
        recordStatusChanged()
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(recordChanged(notification:)),
                                               name: Store.changedNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: observer
    @objc func recordChanged(notification: Notification) {
        guard let r = notification.object as? Item, r === recording else { return  }
        recordStatusChanged()
    }
    
    //MARK: ---update---
    func recordStatusChanged() {
        
        guard let url = recording?.fileURL else {
            updateProgress(progress: 0)
            audioPlayer = nil
            navigationItem.title = ""
            setNoRecordStatus(showOrHidden: true)
            setPlayerStatus(showOrHidden: false)
            return
        }
        
        audioPlayer = Player(url: url, update: { [weak self] (time) in
            if let t = time {
                self?.updateProgress(progress: t)
            }
            else {
                self?.recording = nil
            }
        })
        
        //重新创建player 之后,恢复状态
        if let _ = audioPlayer {
            updateProgress(progress: 0)
            navigationItem.title = recording?.name
            nameTextField?.text = recording?.name
            setPlayerStatus(showOrHidden: true)
            setNoRecordStatus(showOrHidden: false)
        }
        else {
            recording = nil
        }
        
    }
    
    func updateProgress(progress:TimeInterval){
        self.progressLabel.text = timeString(progress)
        let duration = audioPlayer?.duration ?? 0
        self.durationLabel.text = timeString(duration)
        self.progressSlider.maximumValue = Float(duration)
        self.progressSlider.value = Float(progress)
        
        updatePlayButton()
    }
    
    func updatePlayButton()  {
        if audioPlayer?.isPlaying == true {
            playButton.setTitle(.pause, for: .normal)
        }
        else if audioPlayer?.isPaused == true {
            playButton.setTitle(.resume, for: .normal)
        }
        else{
            playButton.setTitle(.play, for: .normal)
        }
    }
    
    func setPlayerStatus(showOrHidden: Bool) {
        nameTextField.isHidden = !showOrHidden
        nameLabel.isHidden = !showOrHidden
        durationLabel.isHidden = !showOrHidden
        progressLabel.isHidden = !showOrHidden
        progressSlider.isHidden = !showOrHidden
        playButton.isHidden = !showOrHidden
    }
    
    func setNoRecordStatus(showOrHidden: Bool) {
        noRecordingLabel.isHidden = !showOrHidden
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let r = recording,let text = textField.text {
            r.setName(text)
            navigationItem.title = text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: ---Action---
    @IBAction func playClick(_ sender: Any) {
        audioPlayer?.start()
        updatePlayButton()
    }
    
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        audioPlayer?.setProgress(TimeInterval(progressSlider.value))
    }
    

}

fileprivate extension String {
    static let uuidPathKey = "uuidPath"
    
    static let pause = NSLocalizedString("Pause", comment: "")
    static let resume = NSLocalizedString("Resume playing", comment: "")
    static let play = NSLocalizedString("Play", comment: "")
}
