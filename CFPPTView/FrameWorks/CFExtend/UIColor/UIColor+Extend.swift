//
//  UIColor+Extend.swift
//  CFPPTView
//
//  Created by 成林 on 15/6/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import Foundation
import UIKit

/**  RGB颜色  */
func rgb(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)->UIColor{
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}