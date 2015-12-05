//
//  MBProgressHUDUtils.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/12/3.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import MBProgressHUD

class MBProgressHUDUtils: NSObject {

    //创建一个等待动画控件,它可以显示在屏幕中央
    static func createHUD()->MBProgressHUD!
    {
        let window = UIApplication.sharedApplication().windows.last
        let HUD = MBProgressHUD(window: window)
        HUD.detailsLabelFont = UIFont.boldSystemFontOfSize(16)
        window?.addSubview(HUD)
        HUD.show(true)
        HUD.removeFromSuperViewOnHide = true
        
        return HUD
    }
    
    static func setHUD(hud:MBProgressHUD, withErrorImageName errorImageName:String, labelText:String! = nil, detailText:String! = nil)
    {
        hud.mode = MBProgressHUDMode.CustomView
        hud.customView = UIImageView(image: UIImage(named: errorImageName))
        if labelText != nil
        {
            hud.labelText = labelText
        }
        
        if detailText != nil
        {
            hud.detailsLabelText = detailText
        }
        
    }
    
}
