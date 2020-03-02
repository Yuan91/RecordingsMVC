//
//  PlayViewController.swift
//  RecordingsMVC
//
//  Created by du on 2020/2/12.
//

import UIKit

class PlayViewController: UIViewController {

    @IBOutlet weak var noRecordingLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    
    var audioPlayer: Player?
    var record: Record? {
        didSet {
            navigationItem.title = record?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let path = record!.path + "/\(record!.name)"
        let url = URL(string: path)!
        
        audioPlayer = Player(url: url, update: { [weak self] (time) in
            print(timeString(time!))
            self?.updateProgress(progress: time)
        })
        
        
    }
    
    func updateProgress(progress:TimeInterval?){
        
        self.progressLabel.text = timeString(progress!)
        let duration = audioPlayer?.duration ?? 0
        self.durationLabel.text = timeString(duration)
        self.progressSlider.maximumValue = Float(duration)
        self.progressSlider.value = Float(progress!)
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
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
