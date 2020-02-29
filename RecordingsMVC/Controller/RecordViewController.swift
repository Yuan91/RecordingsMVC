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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = timeString(0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(NSHomeDirectory())
        let dir = NSHomeDirectory() + "/test.m4a"
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
                print("待处理操作")
            }
            
            self.dismiss(animated: true)
        }
    }
    

}


fileprivate extension String{
    static let saveRecording = NSLocalizedString("Save Record", comment: "")
    static let save = NSLocalizedString("Save", comment: "")
    static let nameForRecording = NSLocalizedString("nameForRecording", comment: "")
}
