//
//  NSDateFormatter+Util.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/11.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

extension NSDateFormatter {
    
    static var sharedInstance:NSDateFormatter
    {
        struct Instance {
            static var formatter: NSDateFormatter?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&(Instance.token)) { () -> Void in
            Instance.formatter = NSDateFormatter()
            Instance.formatter?.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        
        return Instance.formatter!
    }

}
