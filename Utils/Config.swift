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
        static let kPortrait = "portrait"
    }
    struct Profile {
        static var userInfo:ZPOSCUser!
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
        self.Profile.userInfo = user//保存在静态变量中
        let userData = NSKeyedArchiver.archivedDataWithRootObject(user)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(userData, forKey: Key.kProfile)
        
        userDefaults.synchronize()
    }
    
    static func clearProfile()
    {
        self.Profile.userInfo = nil //清除静态变量中的数据
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey(Key.kProfile)

        userDefaults.removeObjectForKey(Key.kPortrait)//同时移除已下载的头像数据
        
        userDefaults.synchronize()
    }
    
    static func getMyProfile()->ZPOSCUser!
    {
        if self.Profile.userInfo != nil
        {
            //仅从静态变量中读取
            return self.Profile.userInfo
        }
        
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
                self.Profile.userInfo = user as! ZPOSCUser //保存在静态变量中
                return self.Profile.userInfo
            }
        }
        return nil
    }

    static func getOwnID()->String!
    {
        if let user = Config.getMyProfile()
        {
            return user.id
        }else
        {
            return nil
        }
    }
    
    static func getUserName()->String!
    {
        if let user = Config.getMyProfile()
        {
            return user.name
        }else
        {
            return "点击头像登录"
        }
    }
    
    // MARK:- Portrait
    
    static func getPortrait()->UIImage!
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let portraitData = userDefaults.objectForKey(Key.kPortrait)
        if portraitData == nil
        {
            return nil
        }
        else
        {
            let portrait = UIImage(data: portraitData as! NSData)
            return portrait
        }
        
    }
    
    static func savePortrait(portrait:UIImage)
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(UIImagePNGRepresentation(portrait), forKey: Key.kPortrait)
        userDefaults.synchronize()
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
