//
//  Foundation+Extend.swift
//  SwiftExtension
//
//  Created by 冯成林 on 15/6/10.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import Foundation

/** 宏定义 */

/** BOOL值 */
let YES = true
let NO = false

/** 零区间 */
let RangeIntervalZero = 0..<0


/**  方向定义  */
enum Direction {
    
    //上
    case Top
    
    //左
    case Left
    
    //下
    case Bottom
    
    //右
    case Right
}

/**  对Int扩展  */
extension Int{
    
    var toCGFloat: CGFloat { return CGFloat(self) }
}

/**  对CGFlout扩展  */
extension CGFloat {
    var toInt: Int { return Int(self) }
}
























