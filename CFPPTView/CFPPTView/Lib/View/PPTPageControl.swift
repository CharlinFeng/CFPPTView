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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //视图准备
        self.viewPrepare()
    }
    
    /**  视图准备  */
    func viewPrepare(){
        
        self.pageIndicatorTintColor = UIColor.grayColor()
        self.currentPageIndicatorTintColor=UIColor.redColor()
        
        //间距
        self.indicatorMargin = 5
        self.userInteractionEnabled = false
    }
    
    
    
}
