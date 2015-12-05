//
//  UIColor.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/9.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

extension UIColor {
    static func colorWithHex(hexValue:Int, alpha:CGFloat)->UIColor?
    {
        return UIColor(red: CGFloat(Double((hexValue & 0xff0000) >> 16) / 255.0),
                     green: CGFloat(Double((hexValue & 0xff00) >> 8) / 255.0),
                      blue: CGFloat(Double(hexValue & 0xff) / 255.0),
                     alpha: alpha)
    }
    
    static func colorWithHex(hexValue:Int)->UIColor?
    {
        return UIColor.colorWithHex(hexValue, alpha: 1.0)
    }
    
    static func themeColor()->UIColor?
    {
        if (UIApplication.sharedApplication().delegate as! AppDelegate).inNightMode
        {
            return UIColor(red: 0.17, green: 0.17, blue: 0.17, alpha: 1.0)
        }else{
            return UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        }
    }
    

    static func navigationBarColor()->UIColor?
    {
        if (UIApplication.sharedApplication().delegate as! AppDelegate).inNightMode
        {
            return UIColor(red: 0.067, green: 0.282, blue: 0.094, alpha: 1.0)
        }else{
            return UIColor.colorWithHex(0x15A230)
        }
    }
    
    static func titleBarColor()->UIColor?
    {
        if (UIApplication.sharedApplication().delegate as! AppDelegate).inNightMode
        {
            return UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        }else{
            return UIColor.colorWithHex(0xe1e1e1)
        }
    }
    
    
    static func titleColor()->UIColor?
    {
        if (UIApplication.sharedApplication().delegate as! AppDelegate).inNightMode
        {
            return UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        }else{
            return UIColor.blackColor()
        }
    }
    
    static func nameColor()->UIColor?
    {
        if (UIApplication.sharedApplication().delegate as! AppDelegate).inNightMode
        {
            return UIColor(red: 37.0/255.0, green: 147.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        }else{
            return UIColor.colorWithHex(0x087221)
        }
    }
    

    static func separatorColor()->UIColor?
    {
        if (UIApplication.sharedApplication().delegate as! AppDelegate).inNightMode
        {
            return UIColor(red: 0.234, green: 0.234, blue: 0.234, alpha: 1.0)
        }else{
            return UIColor(red: 217.0/255.0, green:217.0/255.0, blue:223.0/255.0, alpha:1.0)
        }
    }
    
    static func contentTextColor()->UIColor?
    {
        if (UIApplication.sharedApplication().delegate as! AppDelegate).inNightMode
        {
            return UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        }else{
            return UIColor.colorWithHex(0x272727)
        }
    }
    
    static func refreshControlColor()->UIColor?
    {
        if (UIApplication.sharedApplication().delegate as! AppDelegate).inNightMode
        {
            return UIColor.colorWithHex(0x13502A)
        }else{
            return UIColor.colorWithHex(0x21B04B)
        }
    }
    
    static func lineColor()->UIColor?
    {
        if (UIApplication.sharedApplication().delegate as! AppDelegate).inNightMode
        { 
            return UIColor(red: 18.0/255, green: 144.0/255, blue: 105.0/255, alpha: 0.6)
        }else{
            return UIColor.colorWithHex(0x2bc157)
        }
    }

}
