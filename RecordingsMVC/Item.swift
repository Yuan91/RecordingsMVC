//
//  Item.swift
//  RecordingsMVC
//
//  Created by du on 2020/2/29.
//

import UIKit
/**
添加一条录音的逻辑
1.在录音结束的时候,即将录音的data数据写在本地
2.那么存储的时候,相当于就存储一个 录音的 文件名和路径

创建一个文件夹:
1.创建一个 Folder对象
2.该对象应持有一个数组,可以添加Item; 该对象对应一个本地的本地文件夹,名称为用户输入的名字

文件夹添加内容
1.添加录音,添加录音的文件名 和 路径
2.添加文件夹,添加文件的 名字和路径

 文件夹读取内容:
 1.获取当前文件夹的路径
 2.读取路径下所有的文件,即为界面上显示的内容

 
 Store 层:
 负责文件/文件夹的创建,数据的读取

这种设计会在沙盒创建与文件目录一致的本地目录
 优点很明显结构清晰,读取数据方便.
 缺点的也很明显:需要频繁的进行IO操作,读取文件目录以及内容.文件重名会被覆盖
*/
/**
 反思:
 1.像Store 层 和 Folder 层的一些操作,还是需要错误处理的,至少需要返回一个bool表示操作是否成功
 2.FolderViewController的folder属性 不必设置为可选的.
 因为每一个文件夹界面都会有一个folder对象,所以可以定义个初始化方法 init(folder:Folder)
 */

/**
 新的实现方式:
 1.由一个JSON 文件组织数据,所有的数据都在Libray下
 */
class Item {
    let uuid: UUID
    private(set) var name: String
    //每一个item 都弱引用一个 Store 对象,便于进行文件操作?
    //目前为止,项目内所有的item引用的Store对象都是同一个
    weak var store: Store?
    weak var parent: Folder? {
        didSet {
            //获取store对象引用,方便做数据存储?
            store = parent?.store
        }
    }
    
    init(name: String, uuid: UUID) {
        self.name = name
        self.uuid = uuid
        self.store = nil
    }
    
    var isFolder: Bool {
        return self is Folder
    }
    
    func setName(_ newName: String) {
        name = newName
        if let p = parent {
            let (oldIndex, newIndex) = p.reSort(changedItem: self)
            let setting: [AnyHashable: Any] = [Item.changeReasonKey:Item.renamed,
                                               Item.oldValueKey: oldIndex,
                                               Item.newValueKey: newIndex]
            store?.save(self, userInfo: setting)
        }
    }
    
    func deleted() {
        parent = nil
    }
    
    
    
    // MARK: --------
    //状态恢复
    var uuidPath: [UUID] {
        var path = parent?.uuidPath ?? []
        path.append(uuid)
        return path
    }
    
    //状态恢复
    func item(atUUIDPath path: ArraySlice<UUID>) -> Item? {
        guard let first = path.first, first == uuid else { return nil }
        return self
    }
}

extension Item {
    static let changeReasonKey = "reason"
    static let newValueKey = "newValue"
    static let oldValueKey = "oldValue"
    static let parentFolderKey = "parentFolder"
    static let renamed = "renamed"
    static let added = "added"
    static let removed = "removed"
}
