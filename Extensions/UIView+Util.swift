//
//  UIView+Util.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/23.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

extension UIView {

    func setCornerRadius(cornerRadius:CGFloat)
    {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    func addConstraintsWithVisualFormat(format: String, options opts: NSLayoutFormatOptions, metrics: [String : AnyObject]?, views: [String : AnyObject])
    {
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: opts, metrics: metrics, views: views))
    }
    
    func setBorderWidth(width:CGFloat, color:UIColor)
    {
        self.layer.borderWidth = width
        self.layer.borderColor = color.CGColor
    }
}
