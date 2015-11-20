//
//  NSString+Util.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/17.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

extension NSString {

    func escapeHTML()->NSString
    {
        let result = self.mutableCopy() as! NSMutableString
        result.replaceOccurrencesOfString("&", withString: "&amp;", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, result.length))
        
        result.replaceOccurrencesOfString("<", withString: "&lt;", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, result.length))
        
        result.replaceOccurrencesOfString(">", withString: "&gt;", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, result.length))
        
        result.replaceOccurrencesOfString("\"", withString: "&quot;", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, result.length))
        
        result.replaceOccurrencesOfString("'", withString: "&#39;", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, result.length))
        
        return result
    }
}
