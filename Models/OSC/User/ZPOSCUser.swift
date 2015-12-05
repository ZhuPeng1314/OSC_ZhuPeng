//
//  ZPOSCUser.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/21.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import TBXML

class ZPOSCUser: ZPOSCBaseObject,NSCoding {
    struct Key {
        static let kName        = "name"
        static let kFollowers   = "followers"
        static let kFans        = "fans"
        static let kScore       = "score"
        static let kRelation    = "relation"
        static let kPortrait    = "portrait"
        static let kFavoritecount = "favoritecount"
        static let kGender      = "gender"
        static let kDevplatform = "devplatform"
        static let kExpertise   = "expertise"
        static let kJointime    = "jointime"
        static let kLatestonline = "latestonline"
        
    }
    
    var                id:String!
    var              name:String!
    var    followersCount:Int!
    var         fansCount:Int!
    var             score:Int!
    var     favoriteCount:Int!
    var      relationship:Int!
    var       portraitURL:NSURL!
    var            gender:String!
    var   developPlatform:String!
    var         expertise:String!
    var          location:String!
    var          joinTime:NSDate!
    var lastestOnlineTime:NSDate!
    
    var pinyin:String! //拼音
    var pinyinFirst:String! //拼音首字母
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.id                = aDecoder.decodeStringForKey("uid")
        self.name              = aDecoder.decodeStringForKey(Key.kName)
        self.followersCount    = aDecoder.decodeIntegerForKey(Key.kFollowers)
        self.fansCount         = aDecoder.decodeIntegerForKey(Key.kFans)
        self.score             = aDecoder.decodeIntegerForKey(Key.kScore)
        self.favoriteCount     = aDecoder.decodeIntegerForKey(Key.kFavoritecount)
        self.relationship      = aDecoder.decodeIntegerForKey(Key.kRelation)
        self.portraitURL       = aDecoder.decodeObjectForKey(Key.kPortrait) as? NSURL
        self.gender            = aDecoder.decodeStringForKey(Key.kGender)
        self.developPlatform   = aDecoder.decodeStringForKey(Key.kDevplatform)
        self.expertise         = aDecoder.decodeStringForKey(Key.kExpertise)
        self.location          = aDecoder.decodeStringForKey("location")
        self.joinTime          = aDecoder.decodeObjectForKey(Key.kJointime) as? NSDate
        self.lastestOnlineTime = aDecoder.decodeObjectForKey(Key.kLatestonline) as? NSDate
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject1(id,forKey: "uid")
        aCoder.encodeObject1(name,forKey: Key.kName)
        aCoder.encodeInteger1(followersCount,forKey: Key.kFollowers)
        aCoder.encodeInteger1(fansCount,forKey: Key.kFans)
        aCoder.encodeInteger1(score,forKey: Key.kScore)
        aCoder.encodeInteger1(favoriteCount,forKey: Key.kFavoritecount)
        aCoder.encodeInteger1(relationship,forKey: Key.kRelation)
        aCoder.encodeObject1(portraitURL,forKey: Key.kPortrait)
        aCoder.encodeObject1(gender,forKey: Key.kGender)
        aCoder.encodeObject1(developPlatform,forKey: Key.kDevplatform)
        aCoder.encodeObject1(expertise,forKey: Key.kExpertise)
        aCoder.encodeObject1(location,forKey: "location")
        aCoder.encodeObject1(joinTime,forKey: Key.kJointime)
        aCoder.encodeObject1(lastestOnlineTime,forKey: Key.kLatestonline)
    }
    
    init(element: UnsafeMutablePointer<TBXMLElement>) {
        super.init()
        TBXML.setCurrentElement(element) //该函数为了线程安全的，启用了锁
        
        // 有些API返回用<uid>，有些地方用<userid>，这样写是为了简化处理
        self.id                = TBXML.stringFromCurrentElement(forNames: ["uid","userid"])
        self.location          = TBXML.stringFromCurrentElement(forNames: ["location","from"])
        
        self.name              = TBXML.stringFromCurrentElement(forNamed: Key.kName)
        self.followersCount    = TBXML.intValueFromCurrentElement(forNamed: Key.kFollowers)
        self.fansCount         = TBXML.intValueFromCurrentElement(forNamed: Key.kFans)
        self.score             = TBXML.intValueFromCurrentElement(forNamed: Key.kScore)
        self.relationship      = TBXML.intValueFromCurrentElement(forNamed: Key.kRelation)
        self.portraitURL       = TBXML.URLFromCurrentElement(forNamed: Key.kPortrait)
        self.favoriteCount     = TBXML.intValueFromCurrentElement(forNamed: Key.kFavoritecount)
        self.gender            = TBXML.stringFromCurrentElement(forNamed: Key.kGender)
        self.developPlatform   = TBXML.stringFromCurrentElement(forNamed: Key.kDevplatform)
        self.expertise         = TBXML.stringFromCurrentElement(forNamed: Key.kExpertise)
        self.joinTime          = TBXML.dateFromCurrentElement(forNamed: Key.kJointime)
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








