//
//  NetworkStatusUtils.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/12/5.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import Reachability
import MBProgressHUD

class NetworkStatusUtils: NSObject {
    /*+ (NSInteger)networkStatus
    {
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.oschina.net"];
    return reachability.currentReachabilityStatus;
    }
    
    + (BOOL)isNetworkExist
    {
    return [self networkStatus] > 0;
    }*/
    
    static func getNetworkStatus()->NetworkStatus
    {
        let reachability = Reachability(hostName: "www.oschina.net")
        return reachability.currentReachabilityStatus()
    }
    
    static func isNetworkExist()->Bool
    {
        return NetworkStatusUtils.getNetworkStatus() != NetworkStatus.NotReachable
    }
    
    static func isNoNetworkWithHUD()->Bool
    {
        if NetworkStatusUtils.isNetworkExist() == false
        {
            let HUD = MBProgressHUDUtils.createHUD()
            HUD.mode = MBProgressHUDMode.Text
            HUD.labelText = "网络无连接，请检查网络"
            HUD.hide(true, afterDelay: 1)
            return true
        }else
        {
            return false
        }
    }
}
