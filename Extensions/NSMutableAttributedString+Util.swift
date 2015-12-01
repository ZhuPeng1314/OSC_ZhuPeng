//
//  NSMutableAttributedString+Util.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/28.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {

    func removeUnderLineStyle()
    {
        self.beginEditing()
        
        self.enumerateAttribute(NSUnderlineStyleAttributeName, inRange: NSMakeRange(0, self.length), options: NSAttributedStringEnumerationOptions.init(rawValue: 0)) { (value, range, _) -> Void in
            if value != nil
            {
                self.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(integer: NSUnderlineStyle.StyleNone.rawValue), range: range)
            }
        }
        
        self.endEditing()
    }
}
