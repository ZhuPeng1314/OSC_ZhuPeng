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
        static var textView = {()->UITextView! in
            let textView1 = UITextView(frame: CGRectZero)
            ZPTweetCell.initContentTextView(textView1)
            return textView1
        }()
    }

}
