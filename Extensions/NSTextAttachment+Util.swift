//
//  NSTextAttachment+Util.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/28.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit


extension NSTextAttachment {
    func adjustY(y:CGFloat)
    {
        self.bounds = CGRectMake(0, y, self.image!.size.width, self.image!.size.height)
    }

}
