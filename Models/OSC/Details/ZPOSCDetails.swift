//
//  ZPOSCDetails.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/16.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import TBXML

class ZPOSCDetails: ZPOSCBaseObject {
    struct key {
        static let id = "id"
        static let title = "title"
        static let url = "url"
        static let body = "body"
        static let commentCount = "commentCount"
        static let pubDate = "pubDate"
        static let author = "author"
        static let authorid = "authorid"
        static let favorite = "favorite"
    }
    
    
    var id:String!
    var title:String!
    var body:String!
    var pubDate:NSDate!
    var author:String!
    var authorID:String!
    var commentCount:Int!
    
    var url:NSURL!
    
    var isFavorite:Bool!
    
    var html:String!
    
    init(element:UnsafeMutablePointer<TBXMLElement>)
    {
        super.init()
        self.id = TBXML.stringForElementNamed(key.id, parentElement: element)
        self.title = TBXML.stringForElementNamed(key.title, parentElement: element)
        self.url = NSURL(string: TBXML.stringForElementNamed(key.url, parentElement: element))
        self.body = TBXML.stringForElementNamed(key.body, parentElement: element)
        self.author = TBXML.stringForElementNamed(key.author, parentElement: element)
        self.authorID = TBXML.stringForElementNamed(key.authorid, parentElement: element)
        self.isFavorite = (TBXML.stringForElementNamed(key.favorite, parentElement: element) as NSString).boolValue
        
        initCommentCount(element)
        initPubDate(element)
        
    }
    
    // MARK:- 特殊的属性，可在子类中重载
    //某些视图中key稍有不同或者此属性在某个视图中不存在，可在子类中重载，覆盖掉父类的实现
    
    func initCommentCount(element:UnsafeMutablePointer<TBXMLElement>)
    {
        self.commentCount = (TBXML.stringForElementNamed(key.commentCount, parentElement: element) as NSString).integerValue
    }
    
    func initPubDate(element:UnsafeMutablePointer<TBXMLElement>)
    {
        
        self.pubDate = NSDate.dateFromString(TBXML.stringForElementNamed(key.pubDate, parentElement: element))
    }
    
    func getHtml()->String!
    {
        fatalError("getHtml()必须在子类中实现，getHtml() has not been implemented in subclass")
    }
}







