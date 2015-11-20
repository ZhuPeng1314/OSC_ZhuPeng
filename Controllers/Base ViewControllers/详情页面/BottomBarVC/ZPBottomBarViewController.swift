//
//  ZPBottomBarViewController.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/15.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

class ZPBottomBarViewController: UIViewController {
    
    init(hasAMOdeSwitchButton:Bool)
    {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
