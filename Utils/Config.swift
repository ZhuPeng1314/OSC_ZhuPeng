//
//  Config.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/12/3.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import SSKeychain


class Config: NSObject {
    struct Key {
        static let kService  = "OSChina"
        static let kAccount = "account"
        static let kProfile  = "profile"
        static let kUserID = "userID"
        static let kUserName = "name"
    }
    
    
    // MARK:- 登录账户和密码相关
    static func saveOwnAccount(account:String, password:String)
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(account, forKey: Key.kAccount)
        userDefaults.synchronize()
        
        SSKeychain.setPassword(password, forService: Key.kService, account: account)
    }
    
    static func getOwnAccountAndPassword()->Array<String>!
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let account = userDefaults.objectForKey(Key.kAccount) as! String!
        let pwd = SSKeychain.passwordForService(Key.kService, account: account)
        return [account, pwd]
    }
    
    // MARK:- Profile
    
    static func saveProfile(user:ZPOSCUser) // update也用该方法
    {
        let userData = NSKeyedArchiver.archivedDataWithRootObject(user)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(userData, forKey: Key.kProfile)
        
        userDefaults.setObject(user.id, forKey: Key.kUserID)
        userDefaults.setObject(user.name, forKey: Key.kUserName)
        
        userDefaults.synchronize()
    }
    
    static func clearProfile()
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey(Key.kProfile)
        //userDefaults.setObject(NSNumber(integer: 0), forKey: Key.kProfile)
        
        userDefaults.removeObjectForKey(Key.kUserID)
        //userDefaults.setObject(NSNumber(integer: 0), forKey: Key.kUserID)
        userDefaults.setObject("点击头像登录", forKey: Key.kUserName)
        
        userDefaults.synchronize()
    }
    
    static func getMyProfile()->ZPOSCUser!
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userData = userDefaults.objectForKey(Key.kProfile)
        
        if userData == nil
        {
            return nil
        }else
        {
            let user = NSKeyedUnarchiver.unarchiveObjectWithData(userData as! NSData)
            if user?.isKindOfClass(ZPOSCUser.self) == true
            {
                return user as! ZPOSCUser
            }
        }
        return nil
    }

    static func getOwnID()->String!
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userIdData = userDefaults.objectForKey(Key.kUserID)
        
        if userIdData == nil {return nil}
        
        return userIdData as! String
        
        /*if let user = Config.getMyProfile()
        {
            return user.id
        }else
        {
            return nil
        }*/
    }
    
    static func getUserName()->String!
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userName = userDefaults.objectForKey(Key.kUserName)
        
        if userName == nil { return "点击头像登录" }
        
        return userName as! String
        
        /*
        if let user = Config.getMyProfile()
        {
            return user.name
        }else
        {
            return nil
        }*/
    }
    
    // MARK:- Portrait
    
    static func getPortrait()->UIImage!
    {
        return nil
    }
    
    static func savePortrait(portrait:UIImage)
    {
        
    }
    
    // MARK:- Cookies
    
    static func saveCookies()
    {
        let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies
        let cookiesData = NSKeyedArchiver.archivedDataWithRootObject(cookies!)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(cookiesData, forKey: "sessionCookies")
        userDefaults.synchronize()
    }
    
    static func clearCookies()
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("sessionCookies")
        userDefaults.synchronize()
    }
    
    
    
    
}
