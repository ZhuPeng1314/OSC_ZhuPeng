//
//  ZPOSCUser.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/21.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import TBXML

class ZPOSCUser: ZPOSCBaseObject {
    struct Key {
        static let kName = "name"
        static let kFollowers = "followers"
        static let kFans = "fans"
        static let kScore = "score"
        static let kRelation = "relation"
        static let kPortrait = "portrait"
        static let kFavoritecount = "favoritecount"
        static let kGender = "gender"
        static let kDevplatform = "devplatform"
        static let kExpertise = "expertise"
        static let kJointime = "jointime"
        static let kLatestonline = "latestonline"
        
    }
    
    var id:String!
    var name:String!
    var followersCount:Int!
    var fansCount:Int!
    var score:Int!
    var favoriteCount:Int!
    var relationship:Int!
    var portraitURL:NSURL!
    var gender:String!
    var developPlatform:String!
    var expertise:String!
    var location:String!
    var joinTime:NSDate!
    var lastestOnlineTime:NSDate!
    
    var pinyin:String! //拼音
    var pinyinFirst:String! //拼音首字母
    
    
    init(element: UnsafeMutablePointer<TBXMLElement>) {
        super.init()
        TBXML.setCurrentElement(element) //该函数为了线程安全的，启用了锁
        
        // 有些API返回用<uid>，有些地方用<userid>，这样写是为了简化处理
        self.id = TBXML.stringFromCurrentElement(forNames: ["uid","userid"])
        self.location = TBXML.stringFromCurrentElement(forNames: ["location","from"])
        
        self.name = TBXML.stringFromCurrentElement(forNamed: Key.kName)
        self.followersCount = TBXML.intValueFromCurrentElement(forNamed: Key.kFollowers)
        self.fansCount = TBXML.intValueFromCurrentElement(forNamed: Key.kFans)
        self.score = TBXML.intValueFromCurrentElement(forNamed: Key.kScore)
        self.relationship = TBXML.intValueFromCurrentElement(forNamed: Key.kRelation)
        self.portraitURL = TBXML.URLFromCurrentElement(forNamed: Key.kPortrait)
        self.favoriteCount = TBXML.intValueFromCurrentElement(forNamed: Key.kFavoritecount)
        self.gender = TBXML.stringFromCurrentElement(forNamed: Key.kGender)
        self.developPlatform = TBXML.stringFromCurrentElement(forNamed: Key.kDevplatform)
        self.expertise = TBXML.stringFromCurrentElement(forNamed: Key.kExpertise)
        self.joinTime = TBXML.dateFromCurrentElement(forNamed: Key.kJointime)
        self.lastestOnlineTime = TBXML.dateFromCurrentElement(forNamed: Key.kLatestonline)
        
        TBXML.releaseCurrentElement() //释放锁
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        
        if object!.isKindOfClass(ZPOSCUser.self)
        {
            return (object!.id as NSString).isEqualToString(self.id)
        }
        return false
    }
}








