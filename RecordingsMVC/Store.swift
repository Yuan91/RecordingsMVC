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
    
    /// 初始化
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
    
    /// 获取文件路径
    func fileURL(_ recording: Recording) -> URL? {
        return baseURL?.appendingPathComponent(recording.uuid.uuidString + ".m4a") ?? placeholder
    }
    
    /// 格式化数据存储到本地
    func save(_ notifying: Item, userInfo: [AnyHashable: Any]) {
        if let url = baseURL,let data = try? JSONEncoder().encode(rootFolder) {
            try! data.write(to: url.appendingPathComponent(.storeLocation))
        }
        NotificationCenter.default.post(name: Store.changedNotification,
                                        object: notifying,
                                        userInfo: userInfo)
    }
    
    /// 删除文件
    func deleteFile(for recording:Recording) {
        if let url = fileURL(recording), url != placeholder {
            _ = try! FileManager.default.removeItem(at: url)
        }
    }
}

fileprivate extension String {
    static let storeLocation = "store.json"
}
