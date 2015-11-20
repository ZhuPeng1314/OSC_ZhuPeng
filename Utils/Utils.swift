//
//  Utils.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/12.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import FontAwesome
import MBProgressHUD
import GRMustache

class Utils: NSObject {
    
    //给时间附加图片，并且格式变为 x days ago的形式
    static func attributedTimeString(date : NSDate)->NSAttributedString
    {
        let rawString = "\(NSString.fontAwesomeIconStringForEnum(FAIcon.FAClockO)) \(date.timeAgoSinceNow())"
        
        let attrString = NSAttributedString(string: rawString,
                                            attributes: [NSFontAttributeName : UIFont(awesomeFontOfSize: 12)])
        
        return attrString
    }
    
    //给回复数附加图片
    static func attributedCommentCount(commentCount : Int)->NSAttributedString
    {
        let rawString = "\(NSString.fontAwesomeIconStringForEnum(FAIcon.FACommentsO)) \(commentCount)"
        
        let attrString = NSAttributedString(string: rawString,
                                        attributes: [NSFontAttributeName : UIFont(awesomeFontOfSize: 12)])
        
        return attrString
    }
    
    //创建一个等待动画控件,它可以显示在屏幕中央
    static func createHUD()->MBProgressHUD!
    {
        let window = UIApplication.sharedApplication().windows.last
        let HUD = MBProgressHUD(window: window)
        HUD.detailsLabelFont = UIFont.boldSystemFontOfSize(16)
        window?.addSubview(HUD)
        HUD.show(true)
        HUD.removeFromSuperViewOnHide = true
        
        return HUD
    }
    
    //根据data与模版,创建完整的HTML
    static func HTMLWithData(var data:Dictionary<String,AnyObject>, usingTemplate templateName:String)->String!
    {
        var result:String! = nil
        
        let templatePath = NSBundle.mainBundle().pathForResource(templateName, ofType: "html")
        
        do {
            let template = try String(contentsOfFile: templatePath!, encoding: NSUTF8StringEncoding)
            
            //夜间模式相关的暂时使用固定值
            data["night"] = false
            
            try result = GRMustacheTemplate.renderObject((data as NSDictionary), fromString: template)
           
        }
        catch
        {
            print(error)
        }
        
        return result
    }
    
    //把相关文章的name和url数据转化为html中的div代码
    static func genarateRelativeNewsString(relativeNews relativeNews:Array<Array<String>>!)->String
    {
        if relativeNews == nil || relativeNews.count == 0
        {
            return ""
        }
        
        var middle = ""
        for news in relativeNews
        {
            middle = "\(middle)<a href=\(news[1])>\(news[0])</a><p/>"
        }
        
        return "相关文章<div style='font-size:14px'><p/>\(middle)</div>"
    }

}





