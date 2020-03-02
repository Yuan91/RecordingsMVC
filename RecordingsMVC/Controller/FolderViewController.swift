//
//  FolderViewController.swift
//  RecordingsMVC
//
//  Created by du on 2020/2/12.
//

import UIKit

fileprivate extension String{
    static let showRecorder = "showRecorder"
    static let showPlayer = "showPlayer"
    static let showFolder = "showFolder"
}

class FolderViewController: UITableViewController {
    
    var folder: Folder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleChanged), name: folderContentChangedNotification, object: nil)
        
    }
    
    @objc func handleChanged(){
        tableView.reloadData()
    }
    
    // MARK: - Navigation && Action
    @IBAction func createNewFolder(_ sender: Any) {
        modelTextAlert(title: "Create Folder", accept: "Create", placeholder: "Input folder name") { (string) in
            guard let folderName = string else { return }
            self.folder?.createFloder(name: folderName)
        }
    }
    
    @IBAction func createNewRecording(_ sender: Any) {
        performSegue(withIdentifier: .showRecorder, sender: sender)
    }
    
    //该方法的执行,会在 tableView-didSelecetRowAtIndexPath 之前
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return  }
        
        if identifier == .showFolder {
            guard let folderVc = segue.destination as? FolderViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let item = folder?.items?[indexPath.row] else { return  }
            folderVc.folder = item as? Folder
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else if identifier == .showPlayer{
            guard let playVc = (segue.destination as? UINavigationController)?.topViewController as? PlayViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let item = folder?.items?[indexPath.row] else { return  }
            playVc.record = item as? Record
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else if identifier == .showRecorder{
            guard let recordVc = segue.destination as? RecordViewController else { return }
            recordVc.folder = folder
        }
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder?.items?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = folder?.items?[indexPath.row]
        if item?.isFolder == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath)
            cell.textLabel?.text = "📁" + item!.name
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordingCell", for: indexPath)
            cell.textLabel?.text = "🔊" + item!.name
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
