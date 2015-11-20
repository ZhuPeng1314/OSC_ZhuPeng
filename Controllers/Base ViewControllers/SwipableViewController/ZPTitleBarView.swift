//
//  ZPTitleBarView.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/8.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

protocol ZPTitleBarViewDelegate:UIScrollViewDelegate
{
    func titleBarView(clickedTitleButtonIndex clickedTitleButtonIndex:Int)
}

class ZPTitleBarView: UIScrollView {
    
    var titleButtons:NSMutableArray = NSMutableArray()
    var currentIndex:Int = 0
    //weak var titleBarViewDelegate:ZPTitleBarViewDelegate?

    init(frame: CGRect, titles:Array<String>) {
        super.init(frame: frame)
        let buttonHeight:CGFloat = frame.size.height
        let buttonWidth:CGFloat = frame.size.width / CGFloat(titles.count)
        
        for (index,title) in titles.enumerate()
        {
            let button = UIButton(type: UIButtonType.Custom)
            button.backgroundColor = UIColor.titleBarColor()
            button.titleLabel?.font = UIFont.systemFontOfSize(15)
            button.setTitleColor(UIColor.colorWithHex(0x909090), forState: UIControlState.Normal)
            button.setTitle(title, forState: UIControlState.Normal)
            
            button.frame = CGRect(x: buttonWidth * CGFloat(index), y: 0, width: buttonWidth, height: buttonHeight)
            button.tag = index
            button.addTarget(self, action: "titleButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.titleButtons.addObject(button)
            self.addSubview(button)
            self.sendSubviewToBack(button)
        }
        
        self.contentSize = CGSize(width: frame.size.width, height: frame.size.height)//暂时设计为不可以滑动
        self.showsHorizontalScrollIndicator = false
        let selectedTitle = self.titleButtons[currentIndex] as! UIButton
        selectedTitle.setTitleColor(UIColor.colorWithHex(0x009000), forState: UIControlState.Normal)
        selectedTitle.transform = CGAffineTransformMakeScale(1.2, 1.2)
        

        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setTitleButtonsColor()
    {
        for button  in self.titleButtons
        {
            (button as! UIButton).backgroundColor = UIColor.titleBarColor()
        }
    }
    
    func changeTitleHighlight(toTitleButton:UIButton)
    {
        let oldSelectedTitle = self.titleButtons[currentIndex] as! UIButton
        oldSelectedTitle.setTitleColor(UIColor.colorWithHex(0x909090), forState: UIControlState.Normal)
        oldSelectedTitle.transform = CGAffineTransformIdentity
        
        toTitleButton.setTitleColor(UIColor.colorWithHex(0x009000), forState: UIControlState.Normal)
        toTitleButton.transform = CGAffineTransformMakeScale(1.2, 1.2)
        self.currentIndex = toTitleButton.tag
    }
    
    func titleButtonClicked(sender:UIButton)
    {
        if sender.tag != self.currentIndex
        {
            self.changeTitleHighlight(sender)
            
            if let delegate1 = (self.delegate as? ZPTitleBarViewDelegate)
            {
                delegate1.titleBarView(clickedTitleButtonIndex: currentIndex)
            }
            
        }
    }
    
    

}
