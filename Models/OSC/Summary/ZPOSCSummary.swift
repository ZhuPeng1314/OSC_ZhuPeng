//
//  ZPOSCSummary.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/18.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import TBXML

class ZPOSCSummary: ZPOSCBaseObject {
    struct Key {
        static let kID = "id"
        static let kTitle = "title"
        static let kBody = "body"
        static let kAuthor = "author"
        static let kAuthorID = "authorid"
        static let kCommentCount = "commentCount"
        static let kPubDate = "pubDate"
    }
    
    var id:String!
    var title:String!
    var body:String!
    var commentCount:Int! //Post: replyCount
    var author:String!
    var authorID:String!
    var pubDate:NSDate!
    
    override init() {
        super.init()
    }
    
    required init(element: UnsafeMutablePointer<TBXMLElement>) {
        super.init()
        
        self.id = TBXML.stringForElementNamed(Key.kID, parentElement: element)
        self.initTitle(element: element)
        self.body = TBXML.stringForElementNamed(Key.kBody, parentElement: element)
        self.initAuthor(element: element)
        self.authorID = TBXML.stringForElementNamed(Key.kAuthorID, parentElement: element)
        self.pubDate = TBXML.dateForElementNamed(Key.kPubDate, parentElement: element)
        self.initCommentCount(element: element)
        
    }
    
    func initTitle(element element: UnsafeMutablePointer<TBXMLElement>)
    {
        self.title = TBXML.stringForElementNamed(Key.kTitle, parentElement: element)
    }
    
    func initAuthor(element element: UnsafeMutablePointer<TBXMLElement>)
    {
        self.author = TBXML.stringForElementNamed(Key.kAuthor, parentElement: element)
    }
    
    func initCommentCount(element element: UnsafeMutablePointer<TBXMLElement>)
    {
        self.commentCount = TBXML.intValueForElementNamed(Key.kCommentCount, parentElement: element)
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        
        if object!.isKindOfClass(ZPOSCSummary.self)
        {
            return (object!.id as NSString).isEqualToString(self.id)
        }
        return false
    }
    
    private var attributedCommentCount1 : NSAttributedString!
    var attributedCommentCount : NSAttributedString
        {
        get {
            if attributedCommentCount1 == nil{
                attributedCommentCount1 = Utils.attributedCommentCount(self.commentCount)
            }
            return attributedCommentCount1!
        }
    }
    
    private var attributedPubDate1 : NSAttributedString!
    var attributedPubDate : NSAttributedString
        {
        get {
            if attributedPubDate1 == nil{
                attributedPubDate1 = Utils.attributedTimeString(self.pubDate)
            }
            return attributedPubDate1!
        }
    }
    
    func getAttributedTitle()->NSAttributedString
    {
        fatalError("getAttributedTitle()必须在子类中实现，getHtml() has not been implemented in subclass")
    }
}







