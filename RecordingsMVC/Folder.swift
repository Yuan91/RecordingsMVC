//
//  Folder.swift
//  RecordingsMVC
//
//  Created by du on 2020/2/29.
//

import UIKit

let folderContentChangedNotification = NSNotification.Name("folderContentChanged")

class Folder: Item {
    
    var items: [Item]?
     
    override init(name: String, path: String) {
        super.init(name: name, path: path)
        items = contentsOfFolder() ?? [Item]()
    }
    
    func createFloder(name: String) {
        Store.createFloder(folderName: name, path: fullPath)
        let folder = Folder(name: name, path: fullPath)
        items?.append(folder)
        folderContentChanged()
    }
    
    func addRecord(name:String)  {
        let fullName = name + ".m4a"
        let record = Record(name: fullName, path: self.path)
        items?.append(record)
        folderContentChanged()
    }
    
    func deleteItem(_ item:Item) {
        if let index = items?.firstIndex(of: item) {
            Store.deleteFileAtPath(item.fullPath)
            items?.remove(at: Int(index))
            folderContentChanged()
        }
    }
    
    func folderContentChanged() {
        NotificationCenter.default.post(name: folderContentChangedNotification, object: self)
    }
    
    /// 读取文件夹内容
    func contentsOfFolder() -> [Item]? {
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: fullPath)
            print(contents)
            var items = [Item]()
            for content in contents {
                if content.contains(String.hiddenFile) {
                    continue
                }
                let contentFullPath = fullPath + "/\(content)"
                var isDir = ObjCBool.init(false)
                let isExist = FileManager.default.fileExists(atPath: contentFullPath, isDirectory: &isDir)
                if isDir.boolValue && isExist {//判断是否是文件夹
                    let folder = Folder(name: content, path: fullPath)
                    items.append(folder)
                }
                else if isExist { //文件
                    let record = Record(name: content, path: fullPath)
                    items.append(record)
                }
            }
            return items
        } catch  {
            return nil
        }
    }
    
    
}
