//
//  ZPOSCNews.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/18.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import TBXML

enum NewsType:Int
{
    case StandardNews = 0
    case SoftWare
    case QA
    case Blog
}

class ZPOSCNews: ZPOSCSummary {
    struct KeyNews {
        static let kURL = "url"
        static let kType = "type"
        static let kEventURL = "eventurl"
        static let kAttachment = "attachment"
        static let kAuthorUID2 = "authoruid2"
        
        static let kNewsType = "newstype"
    }
    
    var url:NSURL!
    var type:NewsType!
    var eventURL:NSURL! //活动的URL
    var attachment:String! //用来作为下一级页面的id号
    var authorUID2:String!
    
    private var attrTitle:NSMutableAttributedString!
    var attributedTitle : NSAttributedString
        {
        get {
            if attrTitle == nil
            {
                //判断是否是当天的新闻
                if self.pubDate.daysAgo() == 0
                {
                    let todayIcon = NSTextAttachment()
                    todayIcon.image = UIImage(named: "widget_taday")!
                    
                    attrTitle = NSMutableAttributedString(attributedString: NSAttributedString(attachment: todayIcon))
                    attrTitle.appendAttributedString(NSAttributedString(string: " "+title))
                }else
                {
                    attrTitle = NSMutableAttributedString(string: self.title)
                }
            }
            
            return attrTitle!
        }
    }
    
    override func getAttributedTitle() -> NSAttributedString {
        return self.attributedTitle
    }
    

    override init() {
        super.init()
    }
    
    
    
    required init(element: UnsafeMutablePointer<TBXMLElement>) {
        super.init(element: element)
        
        self.url = TBXML.URLForElementNamed(KeyNews.kURL, parentElement: element)
        
        let newsTypeNode = TBXML.childElementNamed(KeyNews.kNewsType, parentElement: element)
        self.type = NewsType(rawValue: TBXML.intValueForElementNamed(KeyNews.kType, parentElement: newsTypeNode))
        self.eventURL = TBXML.URLForElementNamed(KeyNews.kEventURL, parentElement: newsTypeNode)
        self.authorUID2 = TBXML.stringForElementNamed(KeyNews.kAuthorUID2, parentElement: newsTypeNode)
        //在newsTypeNode有可能不含attachment,则返回值为nil
        self.attachment = TBXML.stringForElementNamed(KeyNews.kAttachment, parentElement: newsTypeNode)
        
        
    }
    
    
    
}





