//
//  UIImage+Extend.swift
//  CFPPTView
//
//  Created by 成林 on 15/6/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
    
    class func imageFromContextWithColor(color: UIColor, size: CGSize)->UIImage{
        
        var rect = CGRect(origin: CGPointZero, size: size)
        
        //开启图片图形上下文
        UIGraphicsBeginImageContextWithOptions(size, NO, 0)
        
        //获取图形上下文
        var context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor);
    
        CGContextFillRect(context, rect);
    
        //获取图像
        var image = UIGraphicsGetImageFromCurrentImageContext();
    
        //关闭上下文
        UIGraphicsEndImageContext();
        
        return image;
        
    }
 }