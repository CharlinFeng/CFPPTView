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
    private var reusableView: UIImageView?
    
    /**  中间的  */
    private var centerView: UIImageView?
    
    private var isNext: Bool?
    
    /**  定时器  */
    private var timer: NSTimer?
    
    private var isFirstRun:Bool = false
    
    private var isAnimationComplete: Bool = false
    
    private var isLongTimefalseDrag: Bool = false
    
    private var holderImage: UIImage {return UIImage(named: "CFPPTView.bundle/holder")!}
    
    var clickImageV: ((index: Int, pptDataModel: PPTDataModel) ->Void)?
    
    
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
    
    var isOnceAction: Bool = false
    
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
        
        //开启分页
        self.pagingEnabled = true
        
        //隐藏水平条
        self.showsHorizontalScrollIndicator = false
        
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
        
        var index = 0
        
        for value in self.dataModles! {
            
            let dataModel = value as PPTDataModel
            
            let imageV: UIImageView = UIImageView()
            
            //开启交互
            imageV.userInteractionEnabled = true
            
            //添加手势
            imageV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapImageV:"))
            
            //创建imageView
            if PPTType.local == self.type {//本地
                imageV.image = dataModel.localImage
            }else{
                imageV.imageWithUrl(dataModel.networkImageUrl, placeHolderImage: self.holderImage)
            }
            
            imageV.contentMode = UIViewContentMode.ScaleAspectFill
            imageV.clipsToBounds = true
            
            //设置tag
            imageV.tag = index
            
            //添加
            self.imageViewArray.append(imageV)
            
            self.addSubview(imageV)
            
            index++
        }
    }
    
    /** 点击事件 */
    func tapImageV(sender: UITapGestureRecognizer){
        
        let index = self.currentPage
        
        let pptDataModel = self.dataModles![index]
        
        if clickImageV == nil {return}
        
        clickImageV!(index: index,pptDataModel: pptDataModel)
    }
    
    
    
    override func layoutSubviews() {
        
        var frame = self.bounds
        
        var index = 0
        
        for imageV in imageViewArray{
            
            frame.origin.x = CGFloat(index) * self.bounds.size.width
            
            imageV.frame = frame
            
            index++
        }
        
  
        
        //配置scrollView
        self.scrollViewPrepare()
    }
    
    /**  配置scrollView  */
    func scrollViewPrepare(){
        
        if self.dataModles?.count == 0{return}
        
        if !isOnceAction {
            
            let width = self.bounds.width
            let height = self.bounds.height
            
            //设置contentSize
            self.contentSize = CGSizeMake(width * 3, height)
            
            self.contentOffset = CGPointMake(width, 0)
             
            let centerImageV = UIImageView()
            
            let dataModel = self.dataModles![0]
            
            //创建imageView
            if PPTType.local == self.type {//本地
                centerImageV.image = dataModel.localImage
            }else{
                centerImageV.imageWithUrl(dataModel.networkImageUrl, placeHolderImage: self.holderImage)
            }
            
            centerImageV.frame = CGRectMake(width, 0, width, height)
            centerImageV.clipsToBounds = true
            //显示模式
            centerImageV.contentMode = UIViewContentMode.ScaleAspectFill
            self.addSubview(centerImageV)
            self.centerView = centerImageV
            
            let reusableImageView = UIImageView()
            //显示模式
            reusableImageView.contentMode = UIViewContentMode.ScaleAspectFill
            reusableImageView.frame = self.bounds
            reusableImageView.clipsToBounds = true
            //记录
            self.reusableView = reusableImageView
            self.isOnceAction = true
        }
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        self.isLongTimefalseDrag = false

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
            self.isLongTimefalseDrag = true
        })
        
        if(self.timer == nil) {return}
        
        self.timerOff()
    
        self.contentOffset = CGPointMake(self.bounds.width, 0)
        
        let dataModel = self.dataModles![self.currentPage]
        
        //创建imageView
        if PPTType.local == self.type {//本地
            self.centerView?.image = dataModel.localImage
        }else{
            self.centerView?.imageWithUrl(dataModel.networkImageUrl, placeHolderImage: self.holderImage)
        }
        
        self.centerView?.contentMode=UIViewContentMode.ScaleAspectFill
        self.centerView?.clipsToBounds = true
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
            Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in

                if(!self.isLongTimefalseDrag){return}
                
                self.timerOn()
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        if(self.timer != nil) {return}

        let offsetX = self.contentOffset.x
        
        let w = self.bounds.width
      
        var f = self.reusableView?.frame
        
        if f == nil { return }
    
        var index = 0
        
        if offsetX > self.centerView?.frame.origin.x { //显示在最右边
            
            f!.origin.x = self.contentSize.width - w

            self.isNext = true
            
            index = self.nextPage
            
        }else if offsetX < self.centerView?.frame.origin.x{ // 显示在最左边
           
            f!.origin.x = 0

            self.isNext = false
            
            
            index = self.lastPage
        }
        
        self.reusableView?.frame = f!
        
        
        let dataModel = self.dataModles![index]
        
        //创建imageView
        if PPTType.local == self.type {//本地
            self.reusableView?.image = dataModel.localImage
        }else{
            self.reusableView?.imageWithUrl(dataModel.networkImageUrl, placeHolderImage: self.holderImage)
        }
        
        self.reusableView?.contentMode = UIViewContentMode.ScaleAspectFill
        self.reusableView?.clipsToBounds = true
        // 2.显示了最左或者最右的图片
        if (offsetX <= 0 || offsetX >= w * 2) {
            // 2.1.交换
            let temp = self.centerView!
            self.centerView = self.reusableView
            self.reusableView = temp
            
            // 2.2.设置显示位置
            self.centerView?.frame = self.reusableView!.frame
            self.contentOffset = CGPointMake(self.bounds.width, 0)
            
            self.reusableView?.removeFromSuperview()
            
            //处理页码
            self.handlePage()
            
        } else {
            
            self.reusableView?.contentMode = UIViewContentMode.ScaleAspectFill
            self.reusableView?.clipsToBounds = true
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
        let timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: Selector("timerAction"), userInfo: nil, repeats: true)
        
        //加入主循环
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        
        //记录
        self.timer = timer
     
        self.isFirstRun = true
        
    }
    
    
    func timerAction(){
        
        if(self.isFirstRun){
            
            if self.dataModles?.count == 0{return}
            
            self.contentOffset = CGPointZero
            
            self.isFirstRun = false
            
            
            let dataModel = self.dataModles![self.currentPage]
            
            //创建imageView
            if PPTType.local == self.type {//本地
                self.centerView?.image = dataModel.localImage
            }else{
                self.centerView?.imageWithUrl(dataModel.networkImageUrl, placeHolderImage: self.holderImage)
            }
            
            self.centerView?.contentMode = UIViewContentMode.ScaleAspectFill
            self.centerView?.clipsToBounds = true
            self.contentOffset = CGPointMake(self.bounds.width * CGFloat(self.currentPage), 0)
        }
        

        if(self.currentPage >= self.pageCount){self.currentPage = 0}
        
        
        var index = self.currentPage + 1
        if(index<0){ index = self.pageCount - 1}
        if(index>=self.pageCount){index = 0}
        
        var centerPage = 1
        if(self.dataModles!.count==1) {centerPage=0}
        
        let dataModel = self.dataModles![centerPage]
        
        //创建imageView
        if PPTType.local == self.type {//本地
            self.centerView?.image = dataModel.localImage
        }else{
            self.centerView?.imageWithUrl(dataModel.networkImageUrl, placeHolderImage: self.holderImage)
        }
        
        self.centerView?.contentMode = UIViewContentMode.ScaleAspectFill
        self.centerView?.clipsToBounds = true
        //执行页码回调
        self.scrollViewPageChangedClosure?(currentPage: index)
        
        
        //当前的offset
        var offsetX = self.contentOffset.x + self.bounds.width
        
        //计算最大的offset
        if(offsetX >= self.bounds.width * CGFloat(self.pageCount)) { offsetX = 0 }
        
        //计算下一页的offset
        let offset = CGPointMake(offsetX, 0)

        self.isAnimationComplete = false
        self.scrollEnabled = false
        UIView.animateWithDuration(1, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            self.contentOffset = offset
            self.scrollEnabled = true
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
    
    deinit{
        scrollViewPageChangedClosure = nil
        timerOff()
    }
    
}
