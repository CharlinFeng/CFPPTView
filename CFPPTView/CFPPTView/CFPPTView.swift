//
//  SwiftPPT.swift
//  SwiftPPT
//
//  Created by 成林 on 15/6/20.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit

class CFPPTView: UIView {

    private var scrollView: PPTScrollView?
    
    private var titleLabel: UILabel?
    
    private var pageControl: PPTPageControl?
    
    private var type: PPTType?
    
    private var dataModels: [PPTDataModel]!
    
    
    
    var clickImageV: ((index: Int, pptDataModel: PPTDataModel) ->Void)?{
        
        didSet{
            self.scrollView?.clickImageV = clickImageV
        }
    }
    
    /**  调用些方法实例化  */
    convenience init(type: PPTType,dataModels:()->[PPTDataModel]){
        
        self.init(frame: CGRectZero)
        
        self.type = type
        
        self.scrollView?.type = type
        
        self.dataModels = dataModels()
        
        //数据来了
        self.dataModelIsComming()
    }
    
    /**  数据来了  */
    func dataModelIsComming(){
        
        if dataModels.count == 0 {return}
        
        //传递数据
        self.scrollView?.dataModles = self.dataModels!;
        
        //共有页码
        self.pageControl?.numberOfPages = self.dataModels!.count
        //默认第一页
        self.updatePage(page: 0)
    }
    
    
    private override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        //视图准备
        self.viewPrepare()
    }
    
    /**  强制实现，此处无用  */
    internal required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        //视图准备
        self.viewPrepare()
    }
    
    /**  视图准备  */
    func viewPrepare(){
        
        //添加scrollView
        self.scroviewPrepare()
        
        //添加标题Label
        self.titleLabelPrepare()
        
        //指示器
        self.pageControlPrepare()
    }
    
    /**  指示器  */
    func pageControlPrepare(){
        
        let pageControl = PPTPageControl()
        //记录
        self.pageControl = pageControl
        
        //添加
        self.addSubview(pageControl)
        
        //添加约束
        pageControl.make_topInsets_topHeight(top: 0, left: 0, right: 0, topHeight: 30)

    }
    
    /**  添加标题Label  */
    func titleLabelPrepare(){
        
        let titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.blackColor()
        //文字居中
        titleLabel.textAlignment = .Center
        //文字颜色
        titleLabel.textColor = UIColor.whiteColor()
        
        self.addSubview(titleLabel)
        
        //记录
        self.titleLabel = titleLabel
        
        //添加约束
        titleLabel.make_topInsets_topHeight(top: 0, left: 0, right: 0, topHeight: 30)
    }
    
    
    func updatePage(page page: Int){
        
        if dataModels.count == 0 {return}
        
        self.titleLabel!.text = self.dataModels![page].titleStr
        
        self.pageControl?.currentPage = page
    }
    
    
    /**  添加scrollView  */
    func scroviewPrepare(){
        
        //创建
        let scrollView = PPTScrollView()
        
        //记录
        self.scrollView = scrollView
        
        //添加
        self.addSubview(scrollView)
        
        //添加约束
        scrollView.make_4Inset(UIEdgeInsetsZero)
        
        //事件：页码改变
        scrollView.scrollViewPageChangedClosure = { [unowned self] (currentPage: Int) -> Void in
            
            self.updatePage(page: currentPage)
        }
    }
    

    /**  关闭定时器  */
    func timerOff(){
        self.scrollView?.timerOff()
    }
    
    /**  打开定时器  */
    func timerOn(){
        self.scrollView?.timerOn()
    }
    
    deinit{
        timerOff()
    }
}
