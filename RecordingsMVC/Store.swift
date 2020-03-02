//
//  Store.swift
//  RecordingsMVC
//
//  Created by du on 2020/2/29.
//

import UIKit

//该类承担一个文件管理的作用
class Store: NSObject {
    
    /// 创建文件夹.已经存在的文件夹不会重复创建
    static func createFloder(folderName:String,path:String) -> Bool{
        let fullPath = path + "/\(folderName)"
        do {
            try FileManager.default.createDirectory(atPath: fullPath, withIntermediateDirectories: true)
            return true
        } catch  {
            print(error)
            return false
        }
    }
    
    
    ///重命名文件
    static func renameFile(oldName: String, newName: String, folderPath: String) -> Bool{
        let pathExtension = URL(string: oldName)?.pathExtension
        let newValue = newName + ".\(pathExtension!)"
        let oldFullPath = folderPath + "/\(oldName)"
        let newFullPath = folderPath + "/\(newValue)"
        do {
            try FileManager.default.moveItem(atPath: oldFullPath, toPath: newFullPath)
            return true
        } catch  {
            return false
        }
    }
    
    ///删除文件
    static func deleteFileAtPath(_ path: String) {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch  {
            print("删除文件失败")
        }
    }
    
}

extension String {
    static let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first ?? ""
    static let rootFolderName = "audio"
    static let hiddenFile = ".DS_Store"
}
