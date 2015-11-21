//
//  ZPTweetsViewController.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/20.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import TBXML

enum TweetsType:Int
{
    case AllTweets
    case HotestTweets
    case OwnTweets
}

class ZPTweetsViewController: ZPObjsViewController {
    
    static let kTweetCellID = "TweetCell"
    var uid:Int64!
    
    init(type: TweetsType)
    {
        super.init()
        switch (type)
        {
        case .AllTweets: self.uid = 0
        case .HotestTweets: self.uid = -1
        case .OwnTweets: break //暂不实现
        }
        
        
        self.needAutoRefresh = (type != .OwnTweets)
        self.refreshInterval = 3600
        self.kLastRefreshTimeKey = "TweetsRefreshInterval-\(type)"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(ZPTweetCell.self, forCellReuseIdentifier: ZPTweetsViewController.kTweetCellID)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func generateURL(forPage page:Int)->String //子类必须实现的方法
    {
        return "\(OSCAPI_PREFIX)\(OSCAPI_TWEETS_LIST)?uid=\(self.uid)&pageIndex=\(page)&\(OSCAPI_SUFFIX)&clientType=android"
    }
    
    /*override func parseXML(xml:ONOXMLDocument)->Array<ONOXMLElement> //子类必须实现的方法
    {
        return (xml.rootElement.firstChildWithTag("tweets").childrenWithTag("tweet") as! Array<ONOXMLElement>)
    }*/
    
    ///用Blog的代码占位---------------
    override func parseXML(tbxml tbxml: TBXML) -> Array<ZPOSCSummary> {
        let blogslist = TBXML.childElementNamed("blogs", parentElement: tbxml.rootXMLElement)
        var blogs = Array<ZPOSCSummary>()
        TBXML.iterateElementsForQuery("blog", fromElement: blogslist) { (blogXML) -> Void in
            let blog = ZPOSCBlog(element: blogXML)
            blogs.append(blog)
        }
        return blogs
    }
    
    override func parseExtraInfo(fromTBXML tbxml: TBXML) {
        
    }

    override func tableviewWillReload(forResponseObjectsCount objCount:Int)//可选
    {
        if self.uid == -1
        {
            self.lastCell.status = LastCellStatus.Finished
        }else if objCount < 20
        {
            self.lastCell.status = LastCellStatus.Finished
        }else
        {
            self.lastCell.status = LastCellStatus.More
        }
    }
    
    override func refreshDidSucceed()//可选
    {
        NSLog("refreshDidSucceed should over ride in subclasses");
    }
    
    override func anotherNetWorking()//可选
    {
        NSLog("anotherNetWorking should over ride in subclasses");
    }

}
