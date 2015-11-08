//
//  ZPTabBarController.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/6.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

class ZPTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let newsSVC = ZPSwipableViewController()
        
        let tweetsSVC = ZPSwipableViewController()
        
        let discoverSB = UIStoryboard.init(name: "Discover", bundle: NSBundle.mainBundle())
        let discoverNav = discoverSB.instantiateViewControllerWithIdentifier("Nav")
        
        let homepageSB = UIStoryboard.init(name: "Homepage", bundle: NSBundle.mainBundle())
        let homepageNav = homepageSB.instantiateViewControllerWithIdentifier("Nav")
        
        self.viewControllers = [newsSVC,tweetsSVC,UIViewController(),discoverNav,homepageNav]
        let title = ["综合","动弹","","发现","我"]
        let images = ["tabbar-news","tabbar-tweet","","tabbar-discover","tabbar-me"]
        let items = self.tabBar.items!
        for var i = 0; i < items.count; i++
        {
            if i == 2
            {
                continue
            }
            items[i].title = title[i]
            items[i].image = UIImage(named: images[i])
            items[i].selectedImage = UIImage(named: "\(images[i])-selected")
        }
        
        items[2].enabled = false
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
