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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = timeString(0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let dir = folder!.fullPath + "/\(String.placeholderName)"
        let url = URL(string: dir)!
        
        audioRecorder = Recorder(url: url, update: { (timeInterval) in
            if let t = timeInterval{
                self.timeLabel.text = timeString(t)
            }
            else{
                self.timeLabel.text = timeString(0)
                self.dismiss(animated: true)
            }
        })
    }
    

    @IBAction func stopClick(_ sender: Any) {
        audioRecorder?.stop()
        modelTextAlert(title: .saveRecording, accept: .save,  placeholder: .nameForRecording) { string in
            if let name = string {
                Store.renameFile(oldName: .placeholderName, newName: name, folderPath: self.folder!.fullPath)
                self.folder?.addRecord(name: name)
            }
            else{
                Store.deleteFileAtPath(self.audioRecorder!.url.absoluteString)
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
