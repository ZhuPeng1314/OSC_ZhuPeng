//
//  ZPOSCSoftwareDetails.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/16.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import TBXML

class ZPOSCSoftwareDetails: ZPOSCDetails {
    struct keySoftware {
        static let commentCount     = "tweetCount"
        static let recommended      = "recommended"
        static let extensionTitle   = "extensionTitle"
        static let license          = "license"
        static let os               = "os"
        static let language         = "language"
        static let recordtime       = "recordtime"
        static let homepage         = "homepage"
        static let document         = "document"
        static let download         = "download"
        static let logo             = "logo"
    }
    
    var isRecommended:Bool!
    var extensionTitle:String!
    var license:String!
    var os:String!
    var language:String!
    var recordTime:String!
    var homepageURL:String!
    var documentURL:String!
    var downloadURL:String!
    var logoURL:String!
    
    override init(element: UnsafeMutablePointer<TBXMLElement>) {
        super.init(element: element)
        
        TBXML.setCurrentElement(element)
        
        self.isRecommended  = TBXML.boolValueFromCurrentElement(forNamed: keySoftware.recommended)
        self.extensionTitle = TBXML.stringFromCurrentElement(forNamed: keySoftware.extensionTitle)
        self.license        = TBXML.stringFromCurrentElement(forNamed: keySoftware.license)
        self.os             = TBXML.stringFromCurrentElement(forNamed: keySoftware.os)
        self.language       = TBXML.stringFromCurrentElement(forNamed: keySoftware.language)
        self.recordTime     = TBXML.stringFromCurrentElement(forNamed: keySoftware.recordtime)
        self.homepageURL    = TBXML.stringFromCurrentElement(forNamed: keySoftware.homepage)
        self.documentURL    = TBXML.stringFromCurrentElement(forNamed: keySoftware.document)
        self.downloadURL    = TBXML.stringFromCurrentElement(forNamed: keySoftware.download)
        self.logoURL        = TBXML.stringFromCurrentElement(forNamed: keySoftware.logo)
        
        TBXML.releaseCurrentElement()
        
    }
    
    override func initCommentCount(xml: UnsafeMutablePointer<TBXMLElement>) {
        self.commentCount = Int(TBXML.stringForElementNamed(keySoftware.commentCount, parentElement: xml))
    }
    
    override func initPubDate(xml: UnsafeMutablePointer<TBXMLElement>) {
        //Software 没有这个属性，所以保持为空
    }
    
    override func getHtml() -> String! {
        if self.html == nil
        {
            let data:Dictionary<String,AnyObject> = [
                "title": "\(extensionTitle) \(title)",
                "authorID": self.authorID,
                "authorName": self.author,
                "content": self.body,
                "recommended": NSNumber(bool: isRecommended),
                "logoURL": logoURL,
                "license": license,
                "language":language,
                "os":os,
                "recordTime":recordTime,
                "homepageURL":homepageURL,
                "documentURL":documentURL,
                "downloadURL":downloadURL
            ]
            html = Utils.HTMLWithData(data, usingTemplate: "software")
        }
        
        return self.html
    }
}









