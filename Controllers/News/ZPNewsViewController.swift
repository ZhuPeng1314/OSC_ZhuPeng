//
//  ZPNewsViewController.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/7.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import AFNetworking
import TBXML
import DateTools

enum NewsListType:Int{
    case AllType = 0
    case News
    case Synthesis
    case SoftwareRenew
    case AllTypeWeekHottest
    case AllTypeMonthHottest
}

class ZPNewsViewController: ZPObjsViewController {
    
    static let kNewsCellID = "NewsCell"
    private var type:NewsListType!
    
    override init() {
        super.init()
    }
    
    init(type type1:NewsListType)
    {
        super.init()
        self.type = type1
        //自动刷新部分 
        //self.needAutoRefresh = true //默认为true
        //self.refreshInterval = 21600; //默认为21600
        self.kLastRefreshTimeKey = "NewsLastRefreshTime-\(type1)"
        //print(kLastRefreshTimeKey)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("ZPNewsViewController init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(ZPNewsCell.self, forCellReuseIdentifier: ZPNewsViewController.kNewsCellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - 重写父类的方法
    
    override func generateURL(forPage page:Int)->String//子类必须实现的方法
    {
        if (type.rawValue < 4)
        {
            return "\(OSCAPI_PREFIX)\(OSCAPI_NEWS_LIST)?catalog=\(type.rawValue)&pageIndex=\(page)&\(OSCAPI_SUFFIX)"
        } else if type == .AllTypeWeekHottest
        {
            return "\(OSCAPI_PREFIX)\(OSCAPI_NEWS_LIST)?show=week"
        } else
        {
            return "\(OSCAPI_PREFIX)\(OSCAPI_NEWS_LIST)?show=month"
        }
        
    }
    
    override func parseXML(tbxml tbxml: TBXML) -> Array<ZPOSCSummary> {
        let newslist = TBXML.childElementNamed("newslist", parentElement: tbxml.rootXMLElement)
        var news = Array<ZPOSCSummary>()
        TBXML.iterateElementsForQuery("news", fromElement: newslist) { (newsItemXML) -> Void in
            let newsItem = ZPOSCNews(element: newsItemXML)
            news.append(newsItem)
        }
        
        return news
    }
    
    override func parseExtraInfo(fromTBXML tbxml: TBXML) {
    }
    
    override func tableviewWillReload(forResponseObjectsCount objCount:Int)//可选
    {
        //super.tableviewWillReload(forResponseObjectsCount: objCount)
        if self.type.rawValue >= 4
        {
            self.lastCell.status = LastCellStatus.Finished
        }else{
            if objCount < 20
            {
                self.lastCell.status = LastCellStatus.Finished
            }else
            {
                self.lastCell.status = LastCellStatus.More
            }
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

    // MARK: - Table view data source and delegate
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(ZPNewsViewController.kNewsCellID, forIndexPath: indexPath) as! ZPNewsCell
        let data = self.objects[indexPath.row] as! ZPOSCSummary
        
        cell.backgroundColor = UIColor.themeColor()
        
        cell.titleLabel.textColor = UIColor.titleColor()
        cell.titleLabel.attributedText = data.getAttributedTitle()
        cell.authorLabel.text = data.author
        cell.timeLabel.attributedText = data.attributedPubDate
        cell.commentCountLabel.attributedText = data.attributedCommentCount
        
        cell.bodyLabel.text = data.body
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let data = self.objects[indexPath.row] as! ZPOSCSummary
        let maxSize = CGSizeMake(tableView.frame.size.width - 16, CGFloat(MAXFLOAT))
        
        self.label.font = UIFont.boldSystemFontOfSize(15)
        self.label.attributedText = data.getAttributedTitle()
        var height = self.label.sizeThatFits(maxSize).height
        
        self.label.font = UIFont.boldSystemFontOfSize(13)
        self.label.text = data.body
        height += self.label.sizeThatFits(maxSize).height
        
        return height+42
    }

    //选中某条新闻
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let news = self.objects[indexPath.row] as! ZPOSCNews
        if news.eventURL != nil
        {
            print("跟活动相关，调用\(news.eventURL)")
        }else if news.url != nil
        {
            self.navigationController?.handleURL(news.url)
        }else
        {
            let detailsVC = ZPNewsDetailsViewController.createDetailsVC(news)
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
        
    }

}




