//
//  AFHTTPRequestOperationManager.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/11.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import AFNetworking

extension AFHTTPRequestOperationManager {
    static func OSCManager()->AFHTTPRequestOperationManager
    {
        let manager = AFHTTPRequestOperationManager(baseURL: nil)
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer.acceptableContentTypes?.insert("text/html")
        manager.requestSerializer.setValue(self.generateUserAgent(), forHTTPHeaderField: "User-Agent")
        
        //print(self.generateUserAgent())
        
        return manager
    }
    
    static func generateUserAgent()->String
    {
        let appVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")
        let device = UIDevice.currentDevice()
        let IDFV = device.identifierForVendor!.UUIDString
        
        return String("OSChina.NET/\(appVersion)/\(device.systemName)/\(device.systemVersion)/\(device.model)/\(IDFV)")
    }
    
}







