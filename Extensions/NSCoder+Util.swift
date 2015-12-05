//
//  NSCoder+Util.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/12/4.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

extension NSCoder {
    func decodeStringForKey(key: String)->String!
    {
        return self.decodeObjectForKey(key) as! String!
    }
    
    
    
    func encodeObject1(objv: AnyObject?, forKey key: String)
    {
        if objv != nil
        {
            self.encodeObject(objv, forKey: key)
        }
    }
    
    func encodeInteger1(intv: Int!, forKey key: String)
    {
        if intv != nil
        {
            self.encodeInteger(intv, forKey: key)
        }
    }
}
