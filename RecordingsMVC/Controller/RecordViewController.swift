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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("RecordViewController--viewDidLoad")
    }
    

    @IBAction func stopClick(_ sender: Any) {
    }
    

}
