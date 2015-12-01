//
//  UILabel+Util.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/23.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

extension UILabel {
    func initLabel(fontSize fontSize:CGFloat, textColor:UIColor, canInteraction:Bool, fatherView:UIView)
    {
        self.font = UIFont.boldSystemFontOfSize(fontSize)
        self.textColor = textColor
        self.userInteractionEnabled = canInteraction
        fatherView.addSubview(self)
    }
    
    struct Measured {
        static var label = UILabel()
    }
}
