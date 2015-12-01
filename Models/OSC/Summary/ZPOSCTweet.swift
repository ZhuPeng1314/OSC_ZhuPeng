//
//  ZPOSCTweet.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/20.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import TBXML
import FontAwesome

class ZPOSCTweet: ZPOSCSummary {
    struct KeyTweet {
        static let kPortrait = "portrait"
        static let kAppclient = "appclient"
        static let kImgSmall = "imgSmall"
        static let kImgBig = "imgBig"
        static let kAttach = "attach"
        static let kLikeCount = "likeCount"
        static let kIsLike = "isLike"
        static let kLikeList = "likeList"
        static let kUser = "user"
    }
    
    struct StaticData {
        static let clients = ["", "", "手机", "Android", "iPhone", "Windows Phone", "微信"]
    }
    
    var portraitURL:NSURL!
    var portraitImage:UIImage!
    var appClient:Int!
    var hasAnImage:Bool!
    
    var smallImgURL:NSURL!
    var smallImg:UIImage!

    var bigImgURL:NSURL!
    var attach:String!
    
    
    var likeCount:Int!
    var isLike:Bool!
    var likeList:Array<ZPOSCUser>!
    
    var cellHeight:CGFloat = 0.0

    required init(element: UnsafeMutablePointer<TBXMLElement>) {
        super.init(element: element)
        self.portraitURL = TBXML.URLForElementNamed(KeyTweet.kPortrait, parentElement: element)
        self.appClient = TBXML.intValueForElementNamed(KeyTweet.kAppclient, parentElement: element)
        // 附图
        self.smallImgURL = TBXML.URLForElementNamed(KeyTweet.kImgSmall, parentElement: element)
        self.hasAnImage = (self.smallImgURL != nil)
        if (hasAnImage!)
        {
            self.bigImgURL = TBXML.URLForElementNamed(KeyTweet.kImgBig, parentElement: element)
        }
        // 语音信息
        self.attach = TBXML.stringForElementNamed(KeyTweet.kAttach, parentElement: element)
        // 点赞
        self.likeCount = TBXML.intValueForElementNamed(KeyTweet.kLikeCount, parentElement: element)
        self.isLike = TBXML.boolValueForElementNamed(KeyTweet.kIsLike, parentElement: element)
        self.likeList = Array<ZPOSCUser>()
        
        let likeListXML = TBXML.childElementNamed(KeyTweet.kLikeList, parentElement: element)
        TBXML.iterateElementsForQuery(KeyTweet.kUser, fromElement: likeListXML) { (userXML) -> Void in
            let user = ZPOSCUser(element: userXML)
            self.likeList.append(user)
        }
        
    }

    //由于没有Title，覆盖掉默认操作
    override func initTitle(element element: UnsafeMutablePointer<TBXMLElement>) {
    }
    
    private var likersString1:NSMutableAttributedString!
    private var likersDetailString1:NSMutableAttributedString!
    
    func getlikersString()->NSMutableAttributedString
    {
        if likersString1 == nil
        {
            likersString1 = initLikersString(3)
        }
        return likersString1
    }
    
    func getlikersDetailString()->NSMutableAttributedString
    {
        if likersDetailString1 == nil
        {
            likersDetailString1 = initLikersString(10)
        }
        return likersDetailString1
    }
    
    private func initLikersString(nameNumber:Int)->NSMutableAttributedString!
    {
        let result = NSMutableAttributedString()
        if self.likeList.count > 0
        {
            var i=0
            for i=0; i<nameNumber-1 && i < likeList.count-1; i++
            {
                let user = self.likeList[i]
                result.appendAttributedString(NSAttributedString(string: "\(user.name)、"))
            }
            result.appendAttributedString(NSAttributedString(string: "\(self.likeList[i].name)"))
            
            //设置颜色
            result.addAttribute(NSForegroundColorAttributeName, value: UIColor.nameColor()!, range: NSMakeRange(0,result.length))
            
            if self.likeList.count > nameNumber
            {
                result.appendAttributedString(NSAttributedString(string: "等\(self.likeCount)人"))
            }
            result.appendAttributedString(NSAttributedString(string: "觉得很赞"))
        }else
        {
            result.appendAttributedString(NSAttributedString(string: ""))
        }
        return result
    }
    
    private var attributedAppclient1:NSMutableAttributedString!
    func getAttributedAppclient()->NSMutableAttributedString!
    {
        if attributedAppclient1 == nil
        {
            if appClient > 1 && appClient <= 6
            {
                attributedAppclient1 = NSMutableAttributedString(string: NSString.fontAwesomeIconStringForEnum(FAIcon.FAMobile), attributes: [NSFontAttributeName:UIFont(awesomeFontOfSize: 13)])
                
                attributedAppclient1.appendAttributedString(NSAttributedString(string: " \(StaticData.clients[appClient])"))
            }else{
                attributedAppclient1 = NSMutableAttributedString(string: "")
            }
        }
        return attributedAppclient1
    }
    
    private var attributedBody1:NSAttributedString!
    func getAttributedBody()->NSAttributedString!
    {
        if attributedBody1 == nil
        {
            self.attributedBody1 = ZPTweetCell.contentStringFromRawString(self.body)
        }
        
        return attributedBody1
    }
    func setAttributedBody(newBody:NSAttributedString)
    {
        self.attributedBody1 = newBody
    }
    
}








