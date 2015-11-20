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
        static let commentCount = "tweetCount"
    }
    
    override init(element: UnsafeMutablePointer<TBXMLElement>) {
        super.init(element: element)
    }
    
    override func initCommentCount(xml: UnsafeMutablePointer<TBXMLElement>) {
        self.commentCount = Int(TBXML.stringForElementNamed(keySoftware.commentCount, parentElement: xml))
    }
    
    override func initPubDate(xml: UnsafeMutablePointer<TBXMLElement>) {
        //Software 没有这个属性，所以保持为空
    }
}
