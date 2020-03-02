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
class Item: NSObject {
    var name: String
    var path: String
    var fullPath: String {
        return self.path + "/" + self.name
    }
    
    init(name: String, path: String){
        self.name = name
        self.path = path
    }
    
    var isFolder: Bool {
        return self is Folder
    }
    
    
}
