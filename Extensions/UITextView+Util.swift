//
//  UITextView+Util.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/28.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

extension UITextView {
    
    struct Meatured {
        static var textView:UITextView
        {
            struct Instance {
                static var textView1: UITextView?
                static var token: dispatch_once_t = 0
            }
            
            dispatch_once(&(Instance.token)) { () -> Void in
                Instance.textView1 = UITextView(frame: CGRectZero)
                ZPTweetCell.initContentTextView(Instance.textView1!)
            }
            
            return Instance.textView1!
        }
    }

}
