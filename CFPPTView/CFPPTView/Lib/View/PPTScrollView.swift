//
//  PPTScrollView.swift
//  SwiftPPT
//
//  Created by 成林 on 15/6/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit


class PPTScrollView: UIScrollView, UIScrollViewDelegate{
    
    var type: PPTType?
    
    /**  循环利用的  */
    var reusableView: UIImageView?
    
    /**  中间的  */
    var centerView: UIImageView?
    
    var isNext: Bool?
    
    /**  定时器  */
    var timer: NSTimer?
    
    var isFirstRun:Bool = NO
    
    var isAnimationComplete: Bool = NO
    
    var isLongTimeNoDrag: Bool = NO
    
    
    lazy var pageCount: Int = { self.dataModles!.count }()
    
    var currentPage: Int = 0 {
        
        didSet{
            
            if(currentPage < 0){currentPage = self.pageCount - 1}
            
            if(currentPage >= self.pageCount) {currentPage = 0}
            
            if(self.currentPage != oldValue && self.pageCount != 0){
                
                //执行页码回调
                self.scrollViewPageChangedClosure?(currentPage: currentPage)
            }
        }
    }
    
    
    var nextPage: Int{
        
        get{
            
            var next = self.currentPage + 1
            
            if(next >= self.pageCount){next = 0}
            
            return next
        }
        
    }
    
    
    var lastPage: Int{
        get{
            
            var next = self.currentPage - 1
            
            if(next < 0){next = self.pageCount - 1}
            
            return next
        }
   
    }
    
    var scrollViewPageChangedClosure:((currentPage: Int)->Void)?
    
    var isOnceAction: Bool = NO
    
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
        
        //开启分页
        self.pagingEnabled = YES
        
        //隐藏水平条
        self.showsHorizontalScrollIndicator = NO
        
        self.delegate = self
    }

    var dataModles: [PPTDataModel]?{
        didSet{
            
            //添加本地图片
            self.localImagesPrepare()
            //运行定时器
            self.timerOn()
        }
    }
    
    /**  图片控件  */
    lazy var imageViewArray: [UIImageView] = Array()
    
    
    /**  添加本地图片  */
    func localImagesPrepare(){
    
        self.dataModles?.enumerate{ (index, value) -> Void in
            
            var dataModel = value as PPTDataModel
            
            var imageV: UIImageView = UIImageView()
            
            //创建imageView
            if PPTType.local == self.type {//本地
                imageV.image = dataModel.localImage
            }else{
                imageV.imageWithUrlStr(dataModel.networkImageUrl, phImage: dataModel.placeHolderImage)
            }
            
            imageV.contentMode = UIViewContentMode.ScaleAspectFill
            imageV.clipsToBounds = YES
            
            //添加
            self.imageViewArray.append(imageV)
            
            self.addSubview(imageV)
        }
    }
    
    override func layoutSubviews() {
        
        var frame = self.bounds
        
        self.imageViewArray.enumerate { (index, value) -> Void in
            
            var imageV = value as UIImageView
            
            var i = (index as Int).toCGFloat
            
            frame.origin.x = i * self.width
            
            imageV.frame = frame
        }
        
        //配置scrollView
        self.scrollViewPrepare()
    }
    
    /**  配置scrollView  */
    func scrollViewPrepare(){
        
        if !isOnceAction {
            
            let width = self.width
            let height = self.height
            
            //设置contentSize
            self.contentSize = CGSizeMake(width * 3, height)
            
            self.contentOffset = CGPointMake(width, 0)
             
            var centerImageV = UIImageView()
            
            var dataModel = self.dataModles![0]
            
            //创建imageView
            if PPTType.local == self.type {//本地
                centerImageV.image = dataModel.localImage
            }else{
                centerImageV.imageWithUrlStr(dataModel.networkImageUrl, phImage: dataModel.placeHolderImage)
            }
            
            centerImageV.frame = CGRectMake(width, 0, width, height)
            centerImageV.clipsToBounds = YES
            //显示模式
            centerImageV.contentMode = UIViewContentMode.ScaleAspectFill
            self.addSubview(centerImageV)
            self.centerView = centerImageV
            
            var reusableImageView = UIImageView()
            //显示模式
            reusableImageView.contentMode = UIViewContentMode.ScaleAspectFill
            reusableImageView.frame = self.bounds
            reusableImageView.clipsToBounds = YES
            //记录
            self.reusableView = reusableImageView
            self.isOnceAction = YES
        }
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        self.isLongTimeNoDrag = NO

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
            Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                
                self.isLongTimeNoDrag = YES
        }
        
        if(self.timer == nil) {return}
        
        self.timerOff()
    
        self.contentOffset = CGPointMake(self.width, 0)
        
        var dataModel = self.dataModles![self.currentPage]
        
        //创建imageView
        if PPTType.local == self.type {//本地
            self.centerView?.image = dataModel.localImage
        }else{
            self.centerView?.imageWithUrlStr(dataModel.networkImageUrl, phImage: dataModel.placeHolderImage)
        }
        
        self.centerView?.contentMode=UIViewContentMode.ScaleAspectFill
        self.centerView?.clipsToBounds = YES
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
            Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in

                if(!self.isLongTimeNoDrag){
                    println("不行")
                    
                    return}
                
                println("可以了")
                
                self.timerOn()
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        if(self.timer != nil) {return}

        var offsetX = self.contentOffset.x
        
        var w = self.width
      
        var f = self.reusableView?.frame
        
        if f == nil { return }
    
        var index = 0
        
        var count = self.dataModles!.count
        
        if offsetX > self.centerView?.frame.origin.x { //显示在最右边
            
            f!.origin.x = self.contentSize.width - w

            self.isNext = YES
            
            index = self.nextPage
            
        }else if offsetX < self.centerView?.frame.origin.x{ // 显示在最左边
           
            f!.origin.x = 0

            self.isNext = NO
            
            
            index = self.lastPage
        }
        
        self.reusableView?.frame = f!
        
        
        var dataModel = self.dataModles![index]
        
        //创建imageView
        if PPTType.local == self.type {//本地
            self.reusableView?.image = dataModel.localImage
        }else{
            self.reusableView?.imageWithUrlStr(dataModel.networkImageUrl, phImage: dataModel.placeHolderImage)
        }
        
        self.reusableView?.contentMode = UIViewContentMode.ScaleAspectFill
        self.reusableView?.clipsToBounds = YES
        // 2.显示了最左或者最右的图片
        if (offsetX <= 0 || offsetX >= w * 2) {
            // 2.1.交换
            var temp = self.centerView!
            self.centerView = self.reusableView
            self.reusableView = temp
            
            // 2.2.设置显示位置
            self.centerView?.frame = self.reusableView!.frame
            self.contentOffset = CGPointMake(width, 0)
            
            self.reusableView?.removeFromSuperview()
            
            //处理页码
            self.handlePage()
            
        } else {
            
            self.reusableView?.contentMode = UIViewContentMode.ScaleAspectFill
            self.reusableView?.clipsToBounds = YES
            self.addSubview(self.reusableView!)
        }
    }
    
    
    /**  处理页码  */
    func handlePage(){
        
        if(self.isNext!){
            
            if self.currentPage >= self.pageCount - 1 {
                self.currentPage = 0
            }else{
                self.currentPage++
            }
            
        }else{
            
            if self.currentPage <= 0 {
                
                self.currentPage = self.pageCount - 1
                
            }else{
                self.currentPage--
            }
        }
    }
    
    /**  打开定时器  */
    func timerOn(){
        
        if self.dragging {return}
        
        if(self.timer != nil && !self.isAnimationComplete) { return }
        
        //新建timer
        var timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: Selector("timerAction"), userInfo: nil, repeats: YES)
        
        //加入主循环
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        
        //记录
        self.timer = timer
     
        self.isFirstRun = YES
        
    }
    
    
    func timerAction(){
        
        if(self.isFirstRun){
            
            self.contentOffset = CGPointZero
            
            self.isFirstRun = NO
            
            
            var dataModel = self.dataModles![self.currentPage]
            
            //创建imageView
            if PPTType.local == self.type {//本地
                self.centerView?.image = dataModel.localImage
            }else{
                self.centerView?.imageWithUrlStr(dataModel.networkImageUrl, phImage: dataModel.placeHolderImage)
            }
            
            self.centerView?.contentMode = UIViewContentMode.ScaleAspectFill
            self.centerView?.clipsToBounds = YES
            self.contentOffset = CGPointMake(self.width * self.currentPage.toCGFloat, 0)
        }
        

        if(self.currentPage >= self.pageCount){self.currentPage = 0}
        
        
        var index = self.currentPage + 1
        if(index<0){ index = self.pageCount - 1}
        if(index>=self.pageCount){index = 0}
        
        var dataModel = self.dataModles![1]
        
        //创建imageView
        if PPTType.local == self.type {//本地
            self.centerView?.image = dataModel.localImage
        }else{
            self.centerView?.imageWithUrlStr(dataModel.networkImageUrl, phImage: dataModel.placeHolderImage)
        }
        
        self.centerView?.contentMode = UIViewContentMode.ScaleAspectFill
        self.centerView?.clipsToBounds = YES
        //执行页码回调
        self.scrollViewPageChangedClosure?(currentPage: index)
        
        
        //当前的offset
        var offsetX = self.contentOffset.x + self.width
        
        //计算最大的offset
        if(offsetX >= self.width * self.pageCount.toCGFloat) { offsetX = 0 }
        
        //计算下一页的offset
        var offset = CGPointMake(offsetX, 0)

        self.isAnimationComplete = NO
        self.scrollEnabled = NO
        UIView.animateWithDuration(1, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            self.contentOffset = offset
            self.scrollEnabled = YES
        })
    
        self.currentPage++
    }
    
    
    /**  关闭定时器  */
    func timerOff(){
        
        if(self.timer == nil) { return }
        
        //关闭
        self.timer?.invalidate()
        
        //清空
        self.timer = nil
    }
    
}
