//
//  CirclePortrait.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/12/6.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

class CirclePortrait: UIImageView {
    
    var noLogin:(()->Void)!
    var hasLogin:(()->Void)!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setBorderWidth(2.0, color: UIColor.whiteColor())
        self.setCornerRadius(self.frame.size.width / 2.0) //圆半径则为宽度的一半
        self.userInteractionEnabled = true
    }
    
    func addTapAction(noLogin noLogin:(()->Void)!, hasLogin:(()->Void)!)
    {
        self.noLogin = noLogin
        self.hasLogin = hasLogin
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapPortrait"))
    }
    
    // MARK:- 点击头像事件
    func tapPortrait()
    {
        if NetworkStatusUtils.isNoNetworkWithHUD() == false //如果无网络会显示1秒钟HUD提示
        {
            if Config.getOwnID() == nil //未登录
            {
                if noLogin != nil
                {
                    noLogin()
                }
            }else{
                if hasLogin != nil
                {
                    hasLogin()
                }
            }
        }
    }
    
    func loadPortrait(portraitURL:NSURL)
    {
        self.asyncLoadImage(portraitURL, defaultImageName: "default-portrait",
            reloadBlock: { (newPortrait) -> Void in
                self.image = newPortrait
            },
            storeBlock: { (newPortrait) -> UIImage! in
                if newPortrait != nil
                {
                    Config.savePortrait(newPortrait)
                }
                return Config.getPortrait()
        })
    }

}
