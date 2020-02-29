//
//  Utilities.swift
//  RecordingsMVC
//
//  Created by du on 2020/2/29.
//

import UIKit
import Foundation

//
private let formatter:DateComponentsFormatter = {
   let f = DateComponentsFormatter()
    f.unitsStyle = .positional
    f.zeroFormattingBehavior = .pad
    f.allowedUnits = [.hour,.minute,.second]
    return f
}()

/**
 timeString 是一个函数
 函数定义:完成特定任务的独立代码块.
 方法:与某些特定类型关联的函数, 依赖 类/结构体/枚举 等类型,没有这些类型也就没有方法可言
 */
func timeString(_ time:TimeInterval) -> String{
    return formatter.string(from: time)!
}

extension UIViewController {
    func modelTextAlert(title:String,accept:String = .ok, cancel:String = .cancel, placeholder:String, callback: @escaping (String?) -> ()){
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = placeholder
        }
        let cancelAction = UIAlertAction(title: cancel, style: .cancel) { _ in
            callback(nil)
        }
        let confirm = UIAlertAction(title: accept, style: .default) { _ in
            callback(alert.textFields?.first?.text)
        }
        alert.addAction(cancelAction)
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }
}

fileprivate extension String{
    static let ok = NSLocalizedString("OK", comment: "")
    static let cancel = NSLocalizedString("Cancel", comment: "")
}
