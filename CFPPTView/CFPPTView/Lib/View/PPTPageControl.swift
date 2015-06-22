//
//  PPTPageControl.swift
//  CFPPTView
//
//  Created by 成林 on 15/6/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit

class PPTPageControl: CorePageControl {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //视图准备
        self.viewPrepare()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //视图准备
        self.viewPrepare()
    }
    
    /**  视图准备  */
    func viewPrepare(){
        
        var size = CGSizeMake(24, 4)
        
        self.pageIndicatorImage = UIImage.imageFromContextWithColor(UIColor.grayColor(), size: size)
        self.currentPageIndicatorImage = UIImage.imageFromContextWithColor(UIColor.cyanColor(), size: size)
        
        //间距
        self.indicatorMargin = 5
    }
    
    
    
}
