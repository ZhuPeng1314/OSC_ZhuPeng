//
//  ZPOSCSummary.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/18.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import Ono

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

    required override init(xml: ONOXMLElement) {
        super.init(xml: xml)
        self.id = xml.firstChildWithTag(Key.kID).stringValue()
        self.title = xml.firstChildWithTag(Key.kTitle).stringValue()
        self.body = xml.firstChildWithTag(Key.kBody).stringValue()
        self.initAuthor(xml)
        if let authorIdNode = xml.firstChildWithTag(Key.kAuthorID)
        {
            self.authorID = authorIdNode.stringValue()
        }
        self.pubDate = NSDate.dateFromString(xml.firstChildWithTag(Key.kPubDate).stringValue())
        self.initCommentCount(xml)
    }
    
    func initAuthor(xml: ONOXMLElement)
    {
        self.author = xml.firstChildWithTag(Key.kAuthor).stringValue()
    }
    
    func initCommentCount(xml: ONOXMLElement)
    {
        self.commentCount = xml.firstChildWithTag(Key.kCommentCount).numberValue().integerValue
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







