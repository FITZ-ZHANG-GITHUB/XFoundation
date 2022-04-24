//
//  Date+Extension.swift
//  XFoundation
//
//  Created by FITZ on 2022/4/22.
//

import Foundation

extension Date: XFoundationCompatible {}
public extension XFoundationWrapper where Base == Date {
    func isToday() -> Bool {
        let calendar = Calendar.current
        //当前时间
        let nowComponents = calendar.dateComponents([.day,.month,.year], from: Date() )
        //self
        let selfComponents = calendar.dateComponents([.day,.month,.year], from: base as Date)
        
        return (selfComponents.year == nowComponents.year) && (selfComponents.month == nowComponents.month) && (selfComponents.day == nowComponents.day)
    }
    
    func isYesterday() -> Bool {
        let calendar = Calendar.current
        //当前时间
        let nowComponents = calendar.dateComponents([.day], from: Date() )
        //self
        let selfComponents = calendar.dateComponents([.day], from: base as Date)
        let cmps = calendar.dateComponents([.day], from: selfComponents, to: nowComponents)
        return cmps.day == 1
    }
    
    /// 获取毫秒时间戳
    var milliStamp : String {
        let timeInterval: TimeInterval = base.timeIntervalSince1970
        /// round 函数返回一个数值，该数值是按照指定的小数位数进行四舍五入运算的结果。除数值外，也可对日期进行舍入运算。
        let millisecond = CLongLong(Darwin.round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    func day() -> Int {
        let components = Calendar.current.dateComponents([.year,.month,.day], from: base)
        return components.day ?? 0
    }
    
    func month() -> Int {
        let components = Calendar.current.dateComponents([.year,.month,.day], from: base)
        return components.month ?? 0
    }
    
    func year() -> Int {
        let components = Calendar.current.dateComponents([.year,.month,.day], from: base)
        return components.year ?? 0
    }
}
