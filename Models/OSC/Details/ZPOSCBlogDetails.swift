//
//  ZPOSCBlogDetails.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/16.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import TBXML

class ZPOSCBlogDetails: ZPOSCDetails {
    struct KeyBlog {
        static let kWhere = "where"
        static let kDocumentType = "documentType"
    }
    
    var where1:String!
    var documentType:Int!
    
    override init(element: UnsafeMutablePointer<TBXMLElement>) {
        super.init(element: element)
        self.where1 = TBXML.stringForElementNamed(KeyBlog.kWhere, parentElement: element)
        self.documentType = Int(TBXML.stringForElementNamed(KeyBlog.kDocumentType, parentElement: element))
    }
    
    override func getHtml()->String!
    {
        if self.html == nil
        {
            
            let data:Dictionary<String,AnyObject> = [
                "title": (self.title as NSString).escapeHTML(),
                "authorID": self.authorID,
                "authorName": self.author,
                "timeInterval": self.pubDate.timeAgoSinceNow(),
                "content": self.body,
            ]
            html = Utils.HTMLWithData(data, usingTemplate: "article")
        }
        
        return self.html
    }
    
    
    

}
