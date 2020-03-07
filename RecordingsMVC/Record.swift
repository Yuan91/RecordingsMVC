//
//  Record.swift
//  RecordingsMVC
//
//  Created by du on 2020/2/29.
//

import UIKit

class Recording: Item, Codable {
    override init(name: String, uuid: UUID) {
        super.init(name: name, uuid: uuid)
    }
    
    var fileURL: URL? {
        return store?.fileURL(self)
    }
    
    //MARK: --- logic ---
    //Recording和Folder 分别重写父类的 deleted 方法
    override func deleted() {
        store?.deleteFile(for: self)
        super.deleted()
    }
    
    // MARK:--- 序列化 ---
    enum RecordingKeys: CodingKey { case name, uuid }
    
    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: RecordingKeys.self)
        let uuid = try c.decode(UUID.self, forKey: .uuid)
        let name = try c.decode(String.self, forKey: .name)
        super.init(name: name, uuid: uuid)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: RecordingKeys.self)
        try c.encode(name, forKey: .name)
        try c.encode(uuid, forKey: .uuid)
    }
}
