//
//  UIView+Extend.swift
//  SwiftPPT
//
//  Created by 成林 on 15/6/20.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import Foundation
import UIKit


extension UIView{
    
    /**  size  */
    var size: CGSize { return self.bounds.size }
    
    /**  width  */
    var width: CGFloat { return self.size.width }
    
    /**  height  */
    var height: CGFloat { return self.size.height }
    
    
    /**  x  */
    var x: CGFloat {
        
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        
        get{
            return self.frame.origin.x
        }
    }
    
    /**  y  */
    var y: CGFloat {
        
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        
        get{
            return self.frame.origin.y
        }
    }
    
    
    
    
    
    
    /**  添加约束:常用  */
    func cf_snp_layoutWithInsets(insets: UIEdgeInsets){
        
        if self.superview != nil {
            
            self.snp_makeConstraints{ (make) -> Void in
                make.edges.equalTo(self.superview!).insets(insets)
            }
        }
    }
    
    
    /**  添加边框  */
    func border(#width: CGFloat, color: UIColor){
        
        self.layer.borderWidth = width
        
        self.layer.borderColor = color.CGColor
    }
    
    
    
}