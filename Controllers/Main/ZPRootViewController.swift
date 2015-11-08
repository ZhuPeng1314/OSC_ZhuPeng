//
//  ZPRootViewController.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/6.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import RESideMenu


class ZPRootViewController: RESideMenu {
    
    override func awakeFromNib() {
        self.parallaxEnabled = false;
        self.scaleContentView = true;
        self.contentViewScaleValue = 0.95;
        self.scaleMenuView = false;
        self.contentViewShadowEnabled = true;
        self.contentViewShadowRadius = 4.5;
        
        // Do any additional setup after loading the view.
        self.contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ZPTabBarController")
        self.leftMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ZPSideMenuViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
