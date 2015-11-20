//
//  NSDate.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/11.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

extension NSDate {

    static func dateFromString(string:String)->NSDate
    {
        return NSDateFormatter.sharedInstance.dateFromString(string)!
    }
}
