//
//  UINavigationController+Router.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/15.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import TOWebViewController

extension UINavigationController {
    func handleURL(url:NSURL)
    {
        var urlString = url.absoluteString
        
        if urlString.containsString("oschina.net")
        {
            //站内链接
            //print("站内链接")
            let index = urlString.startIndex.advancedBy(7)
            urlString = urlString.substringFromIndex(index) //去掉"http://"
            var viewController:UIViewController!
            
            let pathComponents = (urlString as NSString).pathComponents //以斜杠划分urlString
            let prefix = pathComponents[0].componentsSeparatedByString(".")[0] as NSString
            
            if prefix.isEqualToString("my")
            {
                viewController = self.genarateVCWithPrefix_my(pathComponents)
                
            }else if prefix.isEqualToString("www") || prefix.isEqualToString("www")
            {
                viewController = self.genarateVCWithPrefix_www_m(pathComponents)
                
            }else if prefix.isEqualToString("static")
            {
                
            }
            
            if viewController != nil
            {
                self.pushViewController(viewController, animated: true)
                
            } else {
                //对暂时无法处理的URL，直接push浏览器VC
                self.pushWebVC(url)
            }
            
        }else{
            //站外链接，直接push浏览器VC
            self.pushWebVC(url)
        }
    }
    
    // MARK: - 对暂时无法处理的URL或者站外链接，直接push浏览器VC
    private func pushWebVC(url:NSURL)
    {
        let webVC = TOWebViewController(URL: url)
        webVC.hidesBottomBarWhenPushed = true
        self.pushViewController(webVC, animated: true)
    }
    
    // MARK: - 根据前缀产生不同的VC
    
    private func genarateVCWithPrefix_www_m(pathComponents:[String])->UIViewController!
    {
        var viewController:UIViewController!
        let count = pathComponents.count
        if count >= 3 //检查url合法性，防止数组溢出
        {
            let type = pathComponents[1] as NSString
            if type.isEqualToString("news") // 新闻
            { // e.g: www.oschina.net/news/27259/mobile-internet-market-is-small
                viewController = self.genarateStandardNewsVC(newsId: pathComponents[2])
            }else if type.isEqualToString("p") // 软件 e.g.: www.oschina.net/p/jx
            {
                viewController = self.genarateSoftWareNewsVC(attachment: pathComponents[2])
            }else if type.isEqualToString("question") // 问答
            {
            }else if type.isEqualToString("tweet-topic") //话题
            {
                
            }
        }
        return viewController
    }
    
    private func genarateVCWithPrefix_my(pathComponents:[String])->UIViewController!
    {
        var viewController:UIViewController!
        
        if pathComponents.count == 2
        {
            // 个人专页 e.g.: my.oschina.net/dong706
        }else if pathComponents.count == 3
        {
            // 个人专页 e.g.: my.oschina.net/u/12
        }else if pathComponents.count == 4
        {
            let type = pathComponents[2] as NSString
            if type.isEqualToString("blog")
            {
                viewController = self.genarateBlogVC(attachment: pathComponents[3])
                
            }else if type.isEqualToString("tweet")
            {
            }
        }else if pathComponents.count == 5
        {
            let type = pathComponents[3] as NSString
            if type.isEqualToString("blog")
            {
                viewController = self.genarateBlogVC(attachment: pathComponents[4])
            }
        }
        return viewController
    }
    
    // MARK: - 产生不同种类的VC
    
    private func genarateSoftWareNewsVC(attachment attachment:String)->UIViewController!
    {
        return ZPSoftwareDetailsViewController(id:attachment)
    }
    
    private func genarateStandardNewsVC(newsId newsId:String)->UIViewController!
    {
        return ZPNewsDetailsViewController(id:newsId)
    }
    
    private func genarateBlogVC(attachment attachment:String)->UIViewController!
    {
        return ZPBlogDetailsViewController(id:attachment)
    }
    
}










