//
//  XArchiver.swift
//  XFoundation
//
//  Created by FITZ on 2022/4/24.
//

import Foundation

public struct XArchiver<T : Any> {
    
    /// 获取本地归档数据
    /// - Parameter key: 最后路径
    /// - Returns: 对象
    public static func unarchiverSaveDatasWithKey(key: String) -> T? {
        let array = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let fileName = array.first?.appending("/" + key)
        let url = URL(fileURLWithPath: fileName ?? "")
        let data = try? Data(contentsOf: url)
        guard let realData = data else { return nil }
        let unarchiver: NSKeyedUnarchiver?
        if #available(iOS 11.0, *) {
            unarchiver = try? NSKeyedUnarchiver(forReadingFrom: realData)
        } else {
            unarchiver = NSKeyedUnarchiver(forReadingWith: realData)
        }
        guard let realUnarchiver = unarchiver else { return nil }
        let datas:T? = realUnarchiver.decodeObject(forKey: key) as? T
        unarchiver?.finishDecoding()
        return datas
    }
    
    /// 归档数据
    /// - Parameters:
    ///   - key: 最后的路径
    ///   - content: 对象
    /// - Returns: 是否成功
    public static func archiverDataWithKey(key: String, content: T) -> Bool {
        let data: NSMutableData = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        let content = content as AnyObject
        if !content.conforms(to: NSCoding.self) {
            return false
        }
        archiver.encode(content, forKey: key)
        archiver.finishEncoding()
        let array = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let fileName = array.first?.appending("/" + key)
        guard let realFileName = fileName else { return false }
        if data.write(toFile: realFileName, atomically: true) {
            return true
        }
        
        return false
    }
    
    /// 删除指定路径的文件
    /// - Parameter fileName: 路径名
    /// - Returns: 是否成功
    public static func deleteFileWithFileName(fileName: String) -> Bool {
        let fileManager = FileManager.default
        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let uniquePath = filePath?.appending("/" + fileName)
        guard let realUniquePath = uniquePath else { return false }
        if fileManager.fileExists(atPath: realUniquePath) {
            try? fileManager.removeItem(atPath: realUniquePath)
            return true
        }
        return false
    }
}

