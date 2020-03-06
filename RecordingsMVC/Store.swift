//
//  Store.swift
//  RecordingsMVC
//
//  Created by du on 2020/2/29.
//

import UIKit

//该类承担一个文件管理的作用
class Store {
    
   
    
}

extension String {
    static let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first ?? ""
    static let rootFolderName = "audio"
    static let hiddenFile = ".DS_Store"
}
