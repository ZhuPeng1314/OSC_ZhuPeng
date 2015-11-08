//
//  ZPNewsViewController.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/7.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

enum NewsListType:Int{
    case NewsListTypeAllType = 0
    case NewsListTypeNews
    case NewsListTypeSynthesis
    case NewsListTypeSoftwareRenew
    case NewsListTypeAllTypeWeekHottest
    case NewsListTypeAllTypeMonthHottest
}

class ZPNewsViewController: ZPObjsViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(type:NewsListType)
    {
        super.init(style: UITableViewStyle.Plain)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
