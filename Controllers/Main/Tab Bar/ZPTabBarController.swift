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
        
        
        let newsVC = ZPNewsViewController(type: NewsListType.News)
        let hotNewsVC = ZPNewsViewController(type: NewsListType.AllTypeWeekHottest)
        let blogVC = ZPBlogsViewController(type: BlogsType.Latest)
        let recommendBlogVC = ZPBlogsViewController(type: BlogsType.Recommended)

        let newsSVC = ZPSwipableViewController(title: "综合",
                                           subTitles: ["资讯", "热点", "博客", "推荐"],
                                         controllers: [newsVC,hotNewsVC,blogVC,recommendBlogVC],
                                         underTabBar: true)
        let newsNav = self.addNavigationItemForViewController(newsSVC)
        
        /*************************************/
        
        let latestTweetsVC = ZPTweetsViewController(type: TweetsType.AllTweets)
        let hotTweetsVC = ZPTweetsViewController(type: TweetsType.HotestTweets)
        
        let tweetsSVC = ZPSwipableViewController(title: "动弹",
                                             subTitles: ["最新动弹", "热门动弹", "我的动弹"],
                                           controllers: [latestTweetsVC,hotTweetsVC],
                                           underTabBar: true)
        let tweetsNav = self.addNavigationItemForViewController(tweetsSVC)
        
        /*************************************/
        
        let discoverSB = UIStoryboard.init(name: "Discover", bundle: NSBundle.mainBundle())
        let discoverNav = discoverSB.instantiateViewControllerWithIdentifier("Nav")
        
        let homepageSB = UIStoryboard.init(name: "Homepage", bundle: NSBundle.mainBundle())
        let homepageNav = homepageSB.instantiateViewControllerWithIdentifier("Nav")
        
        self.viewControllers = [newsNav,tweetsNav,UIViewController(),discoverNav,homepageNav]
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
    

    func addNavigationItemForViewController(viewController:UIViewController)->UINavigationController
    {
        let navigationController = UINavigationController(rootViewController: viewController)
        
        return navigationController
    }

}
