//
//  ZPDetailsViewController.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/15.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
import TBXML

enum DetailsType:Int
{
    case News = 0
    case Blog
    case Software
}

enum FavoriteType:Int
{
    case Software = 1
    case Topic
    case Blog
    case News
    case Code
}

class ZPDetailsViewController: ZPBottomBarViewController,UIWebViewDelegate,UIScrollViewDelegate {
    
    var commentType:CommentType!
    var favoriteType:FavoriteType!
    var objectID:String!
    
    var detailsURLString:String!
    var commentCount:Int!
    var webURLString:String!
    var detailsView:UIWebView!
    
    var tag:String!
    //var detailsClass:ZPOSCBaseObject.Type? //存储 详情实体数据对象 的类型
    
    var requestManager:AFHTTPRequestOperationManager!
    var HUD:MBProgressHUD!
    
    required init(id:String)
    {
        super.init(hasAMOdeSwitchButton: true)
        self.hidesBottomBarWhenPushed = true //隐藏上一级VC的底部Bar，e.g.：起始新闻列表界面中的tabBar
        self.objectID = id
        initData(id)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
        
        
        //底部操作Bar相关 暂时不实现
        
        self.detailsView = UIWebView()
        self.detailsView.delegate = self
        self.detailsView.scrollView.delegate = self
        self.detailsView.opaque = false //不透明
        self.detailsView.backgroundColor = UIColor.themeColor()
        self.detailsView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(detailsView)
        
        //调整底部bar的图层顺序 暂时不实现
        
        //暂时不实现与底部bar相关的布局约束
        let views:[String:UIView] = ["detailsView":detailsView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[detailsView]|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: views))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[detailsView]|", options: [NSLayoutFormatOptions.AlignAllLeft, NSLayoutFormatOptions.AlignAllRight], metrics: nil, views: views))
        
        //底部操作Bar相关 暂时不实现
        
        //添加等待动画
        self.HUD = Utils.createHUD()
        self.HUD.userInteractionEnabled = false
        
        self.requestManager = AFHTTPRequestOperationManager.OSCManager()
        self.fetchDetails()
        
        //夜间模式相关 暂时不实现
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.HUD.hide(animated)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - 底部Bar的UI设置部分 暂时不实现
    
    // MARK: - 获取数据和刷新
    
    func refresh()
    {
        requestManager.requestSerializer.cachePolicy = NSURLRequestCachePolicy.UseProtocolCachePolicy
        self.fetchDetails()
    }
    
    func fetchDetails()
    {
        requestManager.GET(self.detailsURLString, parameters: nil, success: { (operation, data) -> Void in
            
            let xml = TBXML.getXMLFromUTF8Data(data as! NSData)
            
            if xml == nil
            {//数据无法解析,直接返回上一级
                self.navigationController?.popViewControllerAnimated(true)
            }
            
            let dataNode = TBXML.childElementNamed(self.tag, parentElement: xml.rootXMLElement)
            if dataNode == nil
            { //无数据,直接返回上一级
                self.navigationController?.popViewControllerAnimated(true)
            }else
            {
                let details = self.initDetails(dataNode)
                self.loadDetails(details)
            }
            
            // 底部操作Bar被标记 星 暂时不实现
            
            // 评论数字按钮 暂时不实现
            
            // 下面这一行有可能是多余的代码，暂时先注释
            // if (_commentType == CommentTypeSoftware) {_objectID = ((OSCSoftwareDetails *)details).softwareID;}
            
            // 设置底部BarUI相关的，暂时不实现
            
            
            }) { (operation, error) -> Void in
                print(error)
        }
    }
    
    // MARK: - 初始化各项属性，在子类中实现
    
    func initData(id:String)
    {
        fatalError("initData(id:Int)必须在子类中实现，initData(id:Int) has not been implemented in subclass")
    }
    
    // MARK: - 将网络中得到的details数据载入属性中，在子类中扩展实现
    // (在子类中实现时调用父类该方法)
    func loadDetails(details:ZPOSCDetails!)
    {
        if details != nil
        {
            //将baseURL设为app的地址，以区别网络上的地址与本地生成的页面的地址
            self.detailsView.loadHTMLString(details.getHtml(), baseURL: NSBundle.mainBundle().resourceURL)
        }
    }
    
    // MARK: - 将网络中得到的xml数据载入特定details数据模型中，在子类中实现
    func initDetails(xml:UnsafeMutablePointer<TBXMLElement>)->ZPOSCDetails!
    {
        fatalError("initDetails(xml:UnsafeMutablePointer<TBXMLElement>)必须在子类中实现，initDetails(xml:UnsafeMutablePointer<TBXMLElement>) has not been implemented in subclass")
    }
    
    // MARK: - UIWebView Delegate
    
    // 加载完毕后隐藏加载图标
    func webViewDidFinishLoad(webView: UIWebView) {
        self.HUD.hide(true)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (request.URL!.absoluteString.hasPrefix("file"))
        { //由app产生的页面的absoluteString是用的app的绝对路径，所以是file开头
            //如果不是以file开头，则是用户点击了页面内的其他链接，应该跳转到下一个VC
            return true
        }else{
            //点击了页面内的链接后，一般属于外部链接，会跳转到下一个VC并调用浏览器插件解析
            //如果是站内app可解析链接，也将跳转到下一个VC，生成一个app定制UI的页面
            self.navigationController?.handleURL(request.URL!)
            return false
        }
    }
    
    
}
