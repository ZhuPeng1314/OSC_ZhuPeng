//
//  LastCell.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/12.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

enum LastCellStatus:Int
{
    case NotVisible = 0
    case More
    case Loading
    case Error
    case Finished
    case Empty
}

class LastCell: UIView {

    let statusTexts = ["","点击加载更多","","加载数据出错","加载数据完毕"]
    private var status1:LastCellStatus!
    var status:LastCellStatus! {
        get {
            return status1
        }
        set {
            if newValue == LastCellStatus.Loading
            {
                self.indicator.startAnimating()
                self.indicator.hidden = false
            }else
            {
                self.indicator.startAnimating()
                self.indicator.hidden = true
            }
            
            if newValue == LastCellStatus.Empty
            {
                self.textLabel.text = self.emptyMessage
            }else
            {
                self.textLabel.text = self.statusTexts[newValue.rawValue]
            }
            
            self.status1 = newValue
        }
    }
    var shouldResponseToTouch:Bool {
        get {
            //"更多"或者“出错”信息显示时，可以接受点击
            return self.status == LastCellStatus.More || self.status == LastCellStatus.Error
        }
    }
    
    var emptyMessage:String!
    var textLabel:UILabel!
    private var indicator:UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayout()
        self.backgroundColor = UIColor.themeColor()
        self.status = LastCellStatus.NotVisible
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout()
    {
        self.textLabel = UILabel(frame: self.bounds)
        self.textLabel.backgroundColor = UIColor.themeColor()
        self.textLabel.textColor = UIColor.titleColor()
        self.textLabel.textAlignment = NSTextAlignment.Center
        self.textLabel.font = UIFont.boldSystemFontOfSize(14)
        self.addSubview(self.textLabel)
        
        self.indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        //没加autoresizingMask相关的设置
        self.indicator.color = UIColor(red: 54.0/255.0, green: 54.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        self.indicator.center = self.center
        self.addSubview(self.indicator)
        
    }
    

}
