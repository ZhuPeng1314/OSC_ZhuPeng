//
//  ZPOSCBlog.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/19.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import TBXML

class ZPOSCBlog: ZPOSCSummary {
    
    struct KeyBlog {
        static let kDocumentType = "documentType"
        static let kAuthor = "authorname"
    }

    var documentType:Int!
    
    required init(element: UnsafeMutablePointer<TBXMLElement>) {
        super.init(element: element)
        self.documentType = TBXML.intValueForElementNamed(KeyBlog.kDocumentType, parentElement: element)
    }
    
    override func initAuthor(element element: UnsafeMutablePointer<TBXMLElement>) {
        self.author = TBXML.stringForElementNamed(KeyBlog.kAuthor, parentElement: element)
    }
    
    
    private var attrTitle:NSMutableAttributedString!
    var attributedTitle : NSAttributedString
        {
        get {
            if attrTitle == nil
            {
                //判断是否是原创
                let textAttachment = NSTextAttachment()
                if self.documentType == 0
                {
                    textAttachment.image = UIImage(named: "widget_repost")!
                }else
                {
                    textAttachment.image = UIImage(named: "widget-original")!
                }
                attrTitle = NSMutableAttributedString(attributedString: NSAttributedString(attachment: textAttachment))
                attrTitle.appendAttributedString(NSAttributedString(string: " "+title))
            }
            
            return attrTitle!
        }
    }
    
    override func getAttributedTitle() -> NSAttributedString {
        return self.attributedTitle
    }
}
