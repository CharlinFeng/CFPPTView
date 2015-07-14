//
//  PPTDataModel.swift
//  CFPPTView
//
//  Created by 成林 on 15/6/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import Foundation
import UIKit




class PPTDataModel: NSObject {
    
    /**  本地图片：本地相册模式  */
    var localImage: UIImage?
    
    /**  远程服务器图片地址：网络图片模式  */
    var networkImageUrl: String?
    
    /**  占位图片：网络图片模式  */
    var placeHolderImage: UIImage?
    
    /**  说明文字  */
    var titleStr: String?
    
    /** 原业务模型 */
    var model: AnyObject?
    
    
    init(localImage: UIImage, titleStr: String){
        
        self.localImage = localImage
        
        self.titleStr = titleStr
    }
    
    init(networkImageUrl: String, placeHolderImage: UIImage?, titleStr: String, model: AnyObject?){
        
        self.networkImageUrl = networkImageUrl
        self.placeHolderImage = placeHolderImage
        self.titleStr = titleStr
        self.model = model
    }
    

    
    
}

