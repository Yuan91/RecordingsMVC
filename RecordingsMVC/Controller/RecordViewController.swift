//
//  RecordViewController.swift
//  RecordingsMVC
//
//  Created by du on 2020/2/28.
//

import UIKit

class RecordViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder: Recorder?
    var folder: Folder?
    var recording = Recording(name: "", uuid: UUID())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = timeString(0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let url = folder?.store?.fileURL(recording) else { return }
        print(url.absoluteString)
        
        audioRecorder = Recorder(url: url, update: { (timeInterval) in
            if let t = timeInterval{
                self.timeLabel.text = timeString(t)
            }
            else{
                self.timeLabel.text = timeString(0)
                self.dismiss(animated: true)
            }
        })
        
        if audioRecorder == nil {
            self.dismiss(animated: true)
        }
    }
    

    @IBAction func stopClick(_ sender: Any) {
        audioRecorder?.stop()
        modelTextAlert(title: .saveRecording, accept: .save,  placeholder: .nameForRecording) { string in
            if let name = string {
                self.recording.setName(name)
                self.folder?.add(self.recording)
            }
            else{
                self.recording.deleted()
            }
            self.dismiss(animated: true)
        }
    }
    

}


fileprivate extension String{
    static let saveRecording = NSLocalizedString("Save Record", comment: "")
    static let save = NSLocalizedString("Save", comment: "")
    static let nameForRecording = NSLocalizedString("nameForRecording", comment: "")
    static let placeholderName = "placeholderName.m4a"
}
