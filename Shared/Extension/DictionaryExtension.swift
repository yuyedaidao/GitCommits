//
//  DictionaryExtension.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/24.
//
//  StringExtension.swift
//  YQUtils
//
//  Created by 王叶庆 on 2021/3/1.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

public extension Dictionary {
    
    /// 获取字典第一次出现字段对应的内容
    /// - Parameter path: String
    /// - Returns: Any?
    func getFirst(_ keys: String) -> Any? {
        guard let obj: [String: Any] = self as? [String: Any] else {
            return nil
        }
        
        let seps: [Substring] = keys.split(separator: ",")
        
        for sep in seps {
            let k = String(sep)
            if let item = obj[k] {
                if let itemVal = item as? Int {
                    return itemVal
                }
                if let itemVal = item as? Float {
                    return itemVal
                }
                if let itemVal = item as? [String: Any] {
                    return itemVal
                }
                if let itemVal = item as? [Any] {
                    return itemVal
                }
                if let itemStr = item as? String {
                    if itemStr.isEmpty {
                        continue
                    }
                }
                
                if (item as? NSNull) != nil {
                    continue
                }
                
                return item
            }
        }
        return nil
    }
    
    /// 根据Path查找内容  例如 Dic.getPath("a.b.c")
    /// - Parameter path: String
    /// - Returns: Any?
    func getPath(_ path: String, separator: Character = ".") -> Any? {
        guard let obj: [String: Any] = self as? [String: Any] else {
            return nil
        }
        
        var steps: [Substring] = path.split(separator: separator)
        if steps.isEmpty {
            return nil
        }
        let k = String(steps[0])
        
        guard let nextItem = obj[k] else {
            return nil
        }
        
        if steps.count <= 1 {
            return nextItem
        }
        
        if nextItem is Dictionary {
            steps.remove(at: 0)
            return (nextItem as? Dictionary)?.getPath(steps.joined(separator: "\(separator)"), separator: separator)
        }
        return nil
    }
    
    func value(for keyArray: [String]) -> Any? {
        guard let map = self as? [String: Any] else {
            return nil
        }
        if keyArray.count == 1 {
            return map[keyArray.first!]
        }
        if keyArray.isEmpty {
            return nil
        }
        let result = map[keyArray.first!] as? Self
        return result?.value(for: Array(keyArray.dropFirst())) ?? nil
    }
    
    func value(for keyPath: String) -> Any? {
        let components = keyPath.components(separatedBy: ".")
        guard !components.isEmpty else {
            return nil
        }
        return value(for: components)
    }
    
    /// 返回提供的key对应的value中第一个不为空的value值
    /// - Parameter keys: keys
    /// - Returns: value
    func firstValue(for keys: [Key]) -> Value? {
        for key in keys {
            guard let value = self[key] else {
                continue
            }
            return value
        }
        return nil
    }
    
    /// 字典转JSON字符串
    /// - Returns:
    func toJSONString() -> String? {
        if let d = try? JSONSerialization.data(withJSONObject: self, options: .fragmentsAllowed), let configJson = String(data: d, encoding: .utf8) {
            return configJson
        }
        return nil
    }
}
