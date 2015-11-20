//
//  ZPOSCPostDetails.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/16.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import TBXML

class ZPOSCPostDetails: ZPOSCDetails {
    struct keyPost {
        static let commentCount = "answerCount"
    }
    
    override init(element: UnsafeMutablePointer<TBXMLElement>) {
        super.init(element: element)
    }
    
    override func initCommentCount(xml: UnsafeMutablePointer<TBXMLElement>) {
        self.commentCount = Int(TBXML.stringForElementNamed(keyPost.commentCount, parentElement: xml))
    }
}
