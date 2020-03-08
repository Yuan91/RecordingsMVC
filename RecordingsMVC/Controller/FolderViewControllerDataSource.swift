//
//  FolderViewControllerDataSource.swift
//  RecordingsMVC
//
//  Created by du on 2020/3/8.
//

import UIKit

class FolderViewControllerDataSource:NSObject, UITableViewDataSource {
    var folder: Folder
    
    init(_ folder: Folder){
        self.folder = folder
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  folder.contents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = folder.contents[indexPath.row]
        let identifier = item.isFolder ? "FolderCell" : "RecordingCell"
        let icon = item.isFolder ? "📂" : "🔊"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = icon + item.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
       
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = folder.contents[indexPath.row]
        folder.deleteItem(item)
    }
}
