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

class ZPTweetsViewController: ZPObjsViewController,UITextViewDelegate {
    
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
    
    override func parseXML(tbxml tbxml: TBXML) -> Array<ZPOSCSummary> {
        let tweetslist = TBXML.childElementNamed("tweets", parentElement: tbxml.rootXMLElement)
        var tweets = Array<ZPOSCSummary>()
        TBXML.iterateElementsForQuery("tweet", fromElement: tweetslist) { (tweetXML) -> Void in
            let tweet = ZPOSCTweet(element: tweetXML)
            tweets.append(tweet)
        }
        return tweets
    }
    
    override func handleNewObjects(newObjects:Array<ZPOSCSummary>)//可选
    {
        self.asyncLoadImages(newObjects) //每次加载完新tweet信息(不含图片)后，会重新检索需要加载的头像和图片
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
    
    // MARK:- table view data source and delegate func
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ZPTweetsViewController.kTweetCellID, forIndexPath: indexPath) as! ZPTweetCell
        
        let row = indexPath.row
        let tweet = self.objects[row] as! ZPOSCTweet
        
        if cell.contentTextView.delegate == nil
        {
            cell.contentTextView.delegate = self
            cell.contentTextView.addGestureRecognizer(UIGestureRecognizer(target: self, action: "onTapCellContentText:"))
        }
        
        cell.setSelectableItemWithTag(row)
        cell.backgroundColor = UIColor.themeColor()
        cell.setContentWithTweet(tweet)
        
        cell.portrait.image = tweet.portraitImage ?? UIImage(named: "default-portrait")
        
        if tweet.hasAnImage == true && tweet.smallImgURL != nil
        {
            cell.thumbnail.hidden = false
            cell.thumbnail.image = tweet.smallImg ?? UIImage(named: "loading")
            
        }else
        {
            cell.thumbnail.hidden = true
        }
        
        cell.contentTextView.textColor = UIColor.contentTextColor()
        cell.authorLabel.textColor = UIColor.nameColor()
        
        // 可点击的控件的点击事件 暂时不实现
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = self.objects[indexPath.row] as! ZPOSCTweet
        if tweet.cellHeight > 0.1 { return tweet.cellHeight }//复用之前计算的结果，不再重复计算
        let maxSize = CGSizeMake(tableView.frame.size.width - 60, CGFloat(MAXFLOAT))
        self.label.font = UIFont.boldSystemFontOfSize(14.0)
        self.label.text = tweet.author
        var height = self.label.sizeThatFits(maxSize).height
        
        let meaturedTextView = UITextView.Meatured.textView
        meaturedTextView.attributedText = tweet.getAttributedBody()
        height += meaturedTextView.sizeThatFits(maxSize).height
        
        if tweet.likeCount > 0
        {
            self.label.attributedText = tweet.getlikersString()
            self.label.font = UIFont.systemFontOfSize(12)
            height += self.label.sizeThatFits(maxSize).height + 6
        }
        
        if tweet.hasAnImage == true
        {
            var tempImage = tweet.smallImg
            if tempImage == nil
            {
                tempImage = UIImage(named: "loading")
            }
            height += tempImage.size.height + 5
        }
        
        tweet.cellHeight = height + 39
        
        return tweet.cellHeight
    }
    
    func onTapCellContentText(tap:UITapGestureRecognizer)
    {
        let point = tap.locationInView(self.tableView)
        self.tableView(self.tableView, didSelectRowAtIndexPath: self.tableView.indexPathForRowAtPoint(point)!)
    }
    
    func asyncLoadImages(newObjects:Array<ZPOSCSummary>)
    {
        (newObjects as NSArray).enumerateObjectsUsingBlock { (object, i, _) -> Void in
            let tweet = object as! ZPOSCTweet
            if tweet.portraitImage == nil && tweet.portraitURL != nil
            {
                UIImageView.asyncLoadImage(tweet.portraitURL, reloadBlock: { (_) -> Void in
                    self.tableView.reloadData()
                    }, storeBlock: { (image) -> UIImage! in
                        if image != nil
                        {
                            tweet.portraitImage = image
                        }
                        
                        return tweet.portraitImage
                })
            }
            
            if tweet.smallImg == nil && tweet.smallImgURL != nil
            {
                UIImageView.asyncLoadImage(tweet.smallImgURL, reloadBlock: { (_) -> Void in
                    
                    // 单独刷新某一行会有闪烁，全部reload反而较为顺畅
                    tweet.cellHeight = 0.0 //由于之前用默认加载图片占位，需要重新计算cell高度，故仔此处清零
                    self.tableView.reloadData()
                    
                    }, storeBlock: { (image) -> UIImage! in
                        if image != nil
                        {
                            tweet.smallImg = image
                        }
                        return tweet.smallImg
                })
            }
        }
    }

}









