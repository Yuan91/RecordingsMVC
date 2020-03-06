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
    
    static let recordings = NSLocalizedString("Recordings", comment: "Heading for the list of recorded audio items and folders.")
}

class FolderViewController: UITableViewController {
    
    var folder: Folder = Store.shared.rootFolder {
        didSet {
            print(oldValue)
            tableView.reloadData()
            //判断这个新设置的folder 是否是 rootFolder
            if folder === folder.store?.rootFolder  {
                title = .recordings
            }
            else {
                title = folder.name
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftItemsSupplementBackButton = true
        editButtonItem.tintColor = .darkGray
        navigationItem.leftBarButtonItem = editButtonItem
        
        
    }
    
   
    
    
    
    // MARK: - Navigation && Action
    @IBAction func createNewFolder(_ sender: Any) {
        modelTextAlert(title: "Create Folder", accept: "Create", placeholder: "Input folder name") { (string) in
            print(string ?? "")
        }
    }
    
    @IBAction func createNewRecording(_ sender: Any) {
        performSegue(withIdentifier: .showRecorder, sender: sender)
    }
    
    //该方法的执行,会在 tableView-didSelecetRowAtIndexPath 之前
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return  }
        
        if identifier == .showFolder {
           
        }
        else if identifier == .showPlayer{
           
        }
        else if identifier == .showRecorder{
           
        }
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  folder.contents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = folder.contents[indexPath.row]
        let identifier = item.isFolder ? "FolderCell" : "RecordingCell"
        let icon = item.isFolder ? "📂" : "🔊"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = icon + item.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        guard let item = folder?.items?[indexPath.row] else { return }
//        folder?.deleteItem(item)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
