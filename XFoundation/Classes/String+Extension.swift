//
//  String+Extension.swift
//  XFoundation
//
//  Created by FITZ on 2022/4/22.
//

import Foundation

extension String: XFoundationCompatible {}
public extension XFoundationWrapper where Base == String {
    /// 获取全局唯一不重复字符串
    static var globallyUniqueString: String {
        return ProcessInfo.processInfo.globallyUniqueString
    }
    
    /// 是否是JSON字符串
    var isJsonStyle: Bool {
        let jsondata = base.data(using: .utf8)
        do {
            try JSONSerialization.jsonObject(with: jsondata!, options: .mutableContainers)
            return true
        } catch {
            return false
        }
    }
    
    /// 是否为中文
    var isChinese: Bool {
        for character: Character in base {
            if "\(character)".lengthOfBytes(using: String.Encoding.utf8) != 3 {
                return false
            }
        }
        return true
    }
    
    /// 获取url字符串的所有参数
    var urlParameters: [String: AnyObject]? {
        guard let urlComponents = URLComponents(string: base),
              let queryItems = urlComponents.queryItems
        else { return nil }
        var parameters = [String: AnyObject]()
        queryItems.forEach { item in
            if let existValue = parameters[item.name],
               let value = item.value
            {
                if var existValue = existValue as? [AnyObject] {
                    existValue.append(value as AnyObject)
                } else {
                    parameters[item.name] = [existValue, value] as AnyObject
                }
            } else {
                parameters[item.name] = item.value as AnyObject
            }
        }
        return parameters
    }
    
    /// 使用正则表达式替换
    func pregReplace(pattern: String, with: String,
                     options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: base, options: [],
                                              range: NSMakeRange(0, base.count),
                                              withTemplate: with)
    }
    
    /// 计算字符的尺寸
    func size(font: UIFont, maxWidth: CGFloat, maxHeight: CGFloat) -> CGSize {
        let attrs = [NSAttributedString.Key.font: font]
        let rect: CGRect = base.boundingRect(with: CGSize(width: maxWidth, height: maxHeight),
                                             options: .usesLineFragmentOrigin,
                                             attributes: attrs, context: nil)
        return rect.size
    }
    
    /// 删除前缀
    func delPrefix(_ prefix: String) -> String {
        guard base.hasPrefix(prefix) else { return base }
        return String(base.dropFirst(prefix.count))
    }
    
    /// 删除后缀
    func delSuffix(_ suffix: String) -> String {
        guard base.hasSuffix(suffix) else { return base }
        return String(base.dropLast(suffix.count))
    }
    
    /// 限制只能输入字母和数字
    /// - Returns: 返回过滤后的字符串结果
    func onlyLettersAndNumbersEntered() -> String {
        // 限制只能输入数字和字母
        let set = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789").inverted
        let filtered = (base.components(separatedBy: set) as NSArray).componentsJoined(by: " ")
        return filtered
    }
    
    ///  copy字符串到粘贴板
    func copyPasteboard() {
        if base.count > 0 {
            UIPasteboard.general.string = base
        }
    }
    
}
