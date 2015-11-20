//
//  ZPOSCNews.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/18.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import Ono

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
    
    required init(xml: ONOXMLElement) {
        super.init(xml: xml)
        
        self.url = NSURL(string: xml.firstChildWithTag(KeyNews.kURL).stringValue().stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
        
        let newsTypeNode = xml.firstChildWithTag(KeyNews.kNewsType) as ONOXMLElement
        self.type = NewsType(rawValue: newsTypeNode.firstChildWithTag(KeyNews.kType).numberValue().integerValue)
        self.eventURL = NSURL(string: newsTypeNode.firstChildWithTag(KeyNews.kEventURL).stringValue().stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
        self.authorUID2 = newsTypeNode.firstChildWithTag(KeyNews.kAuthorUID2).stringValue()
        if let attachmentNode = newsTypeNode.firstChildWithTag(KeyNews.kAttachment)
        {//在newsTypeNode有可能不含attachment
            self.attachment = attachmentNode.stringValue()
        }
    }
    
    
    
}
