//
//  Store.swift
//  RecordingsMVC
//
//  Created by du on 2020/2/29.
//

import UIKit

//该类承担一个文件管理的作用
final class Store {
    static let changedNotification = Notification.Name("StoreChanged")
    static private let documentDirectory = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    static let shared = Store(url: documentDirectory)
    
    let baseURL: URL?
    let placeholder: URL?
    private(set) var rootFolder: Folder
    
    init(url: URL?) {
        self.baseURL = url
        self.placeholder = nil
        
        if let u = url,
            let data = try? Data(contentsOf: u.appendingPathComponent(.storeLocation)),
            let folder = try? JSONDecoder().decode(Folder.self, from:data)
        {
            self.rootFolder = folder
        }
        else{
            self.rootFolder = Folder(name: "", uuid: UUID())
        }
        
        rootFolder.store = self
    }
}

fileprivate extension String {
    static let storeLocation = "store.json"
}
