//
//  ZPOSCNewsDetails.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/16.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import TBXML

class ZPOSCNewsDetails: ZPOSCDetails {
    struct KeyNews {
        static let softwarelink = "softwarelink"
        static let softwarename = "softwarename"
        
        static let relativies = "relativies"
        static let relative = "relative"
        static let rtitle = "rtitle"
        static let rurl = "rurl"
    }
    
    var softwareLink:NSURL!
    var softwareName:String!
    var relatives:Array<Array<String>>!
    
    override init(element: UnsafeMutablePointer<TBXMLElement>) {
        super.init(element: element)
        self.softwareLink = NSURL(string: TBXML.stringForElementNamed(KeyNews.softwarelink, parentElement: element))
        self.softwareName = TBXML.stringForElementNamed(KeyNews.softwarename, parentElement: element)
        
        let relativesElement = TBXML.childElementNamed(KeyNews.relativies, parentElement: element)
        self.relatives = Array()
        var relativeElement = TBXML.childElementNamed(KeyNews.relative, parentElement: relativesElement)
        while (relativeElement != nil)
        {
            let rTitle = TBXML.stringForElementNamed(KeyNews.rtitle, parentElement: relativeElement)
            let rURL = TBXML.stringForElementNamed(KeyNews.rurl, parentElement: relativeElement)
            relatives.append([rTitle,rURL])
            relativeElement = TBXML.nextSiblingNamed(KeyNews.relative, searchFromElement: relativeElement)
        }
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
                "softwareLink": self.softwareLink,
                "softwareName": self.softwareName,
                "relatedInfo": Utils.genarateRelativeNewsString(relativeNews: self.relatives)
                ]
            html = Utils.HTMLWithData(data, usingTemplate: "article")
        }
        
        return self.html
    }
    

}









