
# CFPPTView
   Swift版幻灯，scrollView无限滚动，支持网络和本地图片展示！

<br /><br />
<br />

框架截图 CUT
===============
![image](./CFPPTView/show2.gif)<br />

<br /><br />



框架说明 EXPLAIN
===============
    Swfit时代的到来！
    此是我第一个swift版本的框架，此框架意味着我正式进入swift时代，
    以后所有项目和框架均全部以swift为开发语言，不再开发OC框架和程序。
    请注意一下细节：
    OC框架和Swift框架为了版权的目的，都有前缀
    OC:     Core(Core系列)
    Swift:  CF (意为Charlin Feng)

<br /><br />

OC版本 OC
===============
之前写了一个OC版本（基于CollectionView）：<br />
https://github.com/nsdictionary/CorePPTVC <br />
<br /><br />







框架特性 FEATURE
===============
>1.swift代码编写。<br />
>2.ios7.0 系统以上。<br />
>3.scrollView实现无限滚动，自动滚动展示。<br />
>4.支持本地图片幻灯数据与网络图片幻灯。<br />
>5.使用简单，一键集成。<br />


<br /><br />


框架依赖 DEPENDENCE
===============
.CoreSDWebImage(OC)<br />
.CorePageControl(OC)<br />
<br /><br />







使用说明 USAGE
===============

#### 1. 使用了OC框架（之前的OC框架一样可以使用的）
   请查看项目中Supporting Files下有一个OC.h,这是一个桥文件，
   在build settings里面swift编译的时候，把oc桥文件指向$(SRCROOT)/$(TARGET_NAME)/oc.h
   关于桥文件的使用以及swift和oc混编，这里不再赘述。
  
#### 2. 由于swift自动引入，不用导入任何头文件，直接使用

#### 2.1  本地幻灯：请注意直接构造方法传入正确的type值并在closure内返回幻灯模型
        //创建并展示一个本地幻灯：
        //创建SwiftPPT
        var pptView = CFPPTView(type: PPTType.local) { () -> [PPTDataModel] in
            
            var localImages = [UIImage(named: "local1"),UIImage(named: "local2"),UIImage(named: "local3"),UIImage(named: "local4")]
            
            var localTitleStr = ["本地幻灯：花千骨剧照一","本地幻灯：花千骨剧照二","本地幻灯：花千骨剧照三","本地幻灯：花千骨剧照四"]
            
            var dataModels: [PPTDataModel] = Array()
            
            for i in 0..<localImages.count {
                
                var dataModel = PPTDataModel(localImage: localImages[i]!, titleStr: localTitleStr[i])
            
                dataModels.append(dataModel)
            }
            
            return dataModels
        }
        pptView.frame = CGRectMake(0, 80, Screen.width, 160)
        
        self.view.addSubview(pptView)
        

#### 2.2  网络幻灯：请注意直接构造方法传入正确的type值并在closure内返回幻灯模型

        //创建并展示一个网络幻灯：
        //创建SwiftPPT
        var pptView2 = CFPPTView(type: PPTType.netWork) { () -> [PPTDataModel] in
            
            var networkImages = ["http://img.netbian.com/file/2015/0619/e8ffa0a298a4f7374df0e599c4fa134d.jpg","http://img.netbian.com/file/20150319/0a176c7518b4b1e9041bb4ada0899160.jpg","http://img.netbian.com/file/20150114/96e7591ea70c43b06c47503a9d31c2f6.jpg","http://img.netbian.com/file/20141129/35b2d754f2eec0a41381115ccf46c2f4.jpg","http://img.netbian.com/file/20140511/2f42b589066cb7baba9f8a3ab820dd45.jpg"]
            
            var networkTitleStr = ["网络幻灯:小黄人一","网络幻灯:小黄人","网络幻灯:小黄人三","网络幻灯:小黄人四","网络幻灯:小黄人五"]
            
            var dataModels: [PPTDataModel] = Array()
            
            for i in 0..<networkImages.count {
                
                var dataModel = PPTDataModel(networkImageUrl: networkImages[i], placeHolderImage: nil, titleStr: networkTitleStr[i])
                dataModels.append(dataModel)
            }
            
            return dataModels
        }
        
        pptView2.frame = CGRectMake(0, 260, Screen.width, 160)
        
        self.view.addSubview(pptView2)

#### 3 性能问题：幻灯内含有定时器，你可以根据以下API自行处理

        /**  关闭定时器  */
        func timerOff(){
            self.scrollView?.timerOff()
        }
        
        /**  打开定时器  */
        func timerOn(){
            self.scrollView?.timerOn()
        }

#### 4 点击事件回调，请注意pptDataModel内部可传业务模型.model，方便你回调取用，

        pptView.clickImageV = {(index: Int, pptDataModel: PPTDataModel) -> Void in
            
            println(index)
        }



