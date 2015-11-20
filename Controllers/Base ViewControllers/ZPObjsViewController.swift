//
//  ZPObjsViewController.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/7.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import AFNetworking
import Ono
import MJRefresh

protocol ZPObjsViewControllerDelegate:NSObjectProtocol
{

    
}

class ZPObjsViewController: UITableViewController {
    
    var objClass:ZPOSCSummary.Type? //存储实体数据对象的类型
    
    var objects = NSMutableArray() //存储所有实体数据对象
    var allCount:Int = 0
    var page:Int = 0
    
    private var requestManager:AFHTTPRequestOperationManager!
    var shouldFetchDataAfterLoaded = true //如果为false则viewDidLoaded方法中不获取数据
    var needCache = true
    var label = UILabel() //用来计算动态变化的行高，并不显示该控件，只是为了利用它的sizeThatFits方法
    
    var lastCell:LastCell!
    
    //与自动刷新相关的属性
    var needAutoRefresh = true
    var kLastRefreshTimeKey = "ZPObjsViewController"
    var refreshInterval:NSTimeInterval = 21600.0
    
    
    
    init()
    {
        super.init(style: UITableViewStyle.Plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor.themeColor()
        
        //LastCell部分
        self.lastCell = LastCell(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, 44))
        self.lastCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "fetchMore"))
        self.tableView.tableFooterView = self.lastCell
        
        //MJRefresh Header部分
        let header1 = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refresh")
        //header1.stateLabel?.hidden = true
        //header1.lastUpdatedTimeLabel?.hidden = true
        self.tableView.mj_header = header1 // mj_header的类型是MJRefreshNormalHeader的父类
        
        self.label.numberOfLines = 0 //不限行数
        self.label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        //self.font 在具体计算中指定
        
        //自动刷新的初始计时
        if self.needAutoRefresh
        {
            header1.lastUpdatedTimeKey = header1.lastUpdatedTimeKey + self.kLastRefreshTimeKey
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: header1.lastUpdatedTimeKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        //获取HTTP请求管理器
        self.requestManager = AFHTTPRequestOperationManager.OSCManager()
        
        if self.shouldFetchDataAfterLoaded == false { return }
        
        //刷新动画暂时不实现
        
        if self.needCache == true
        {
            requestManager.requestSerializer.cachePolicy = NSURLRequestCachePolicy.UseProtocolCachePolicy
        }
        
        self.fetchObjectsOnPage(0, refresh: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 获取数据 主方法
    
    func fetchObjectsOnPage(page:Int, refresh:Bool)
    {
        requestManager.GET(self.generateURL(forPage: page), parameters: nil, success: { (operation, data) -> Void in
            let responseDocument = data as! ONOXMLDocument
            
            //NSLog("\(responseDocument)");
            let objectsXML = self.parseXML(responseDocument)
            
            if (refresh)
            {
                self.page = 0
                self.objects.removeAllObjects()
                self.refreshDidSucceed()
            }
            
            self.parseExtraInfo(fromDocument: responseDocument)
            
            for objXML in objectsXML
            {
                var shouldBeAdded = true
                let obj = self.objClass!.init(xml: objXML)
                
                for existsObj in self.objects
                {
                    if obj.isEqual(existsObj)
                    {
                        shouldBeAdded = false
                        break
                    }
                }
                
                if shouldBeAdded
                {
                    self.objects.addObject(obj)
                }
            }
            
            //自动刷新的部分 暂时不实现
            
            
            //主线程中刷新UI
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //刷新UI前的操作，可在子类中重写
                self.tableviewWillReload(forResponseObjectsCount: objectsXML.count)
                
                //顶部刷新控件
                if self.tableView.mj_header.isRefreshing()
                {
                    self.tableView.mj_header.endRefreshing()
                }
                
                //表格重载数据,即刷新UI
                self.tableView.reloadData()
            })
            
            
            }) { (operation, error) -> Void in
                //请求失败
                print(error)
        }
    }
    
    func refresh()
    {
        self.fetchObjectsOnPage(0, refresh: true)
        
        //刷新时，增加另外的网络请求功能
        self.anotherNetWorking()
        
        //刷新后滚动到最顶部
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.None, animated: false)
    }
    
    func fetchMore()
    {
        if self.lastCell.shouldResponseToTouch == false {return}
        
        self.lastCell.status = LastCellStatus.Loading
        self.requestManager.requestSerializer.cachePolicy = NSURLRequestCachePolicy.UseProtocolCachePolicy
        self.fetchObjectsOnPage(++page, refresh: false)
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height)
        {
            self.fetchMore()
        }
    }

    // MARK: - 供子类实现的方法
    
    func generateURL(forPage page:Int)->String //子类必须实现的方法
    {
        fatalError("generateURL has not been implemented, it should over ride in subclasses \(self.dynamicType)")
    }
    
    func parseXML(xml:ONOXMLDocument)->Array<ONOXMLElement> //子类必须实现的方法
    {
        fatalError("parseXML has not been implemented, it should over ride in subclasses \(self.dynamicType)")
    }
    
    func parseExtraInfo(fromDocument document:ONOXMLDocument)//可选
    {
        NSLog("parseExtraInfo should over ride in subclasses");
    }
    
    func tableviewWillReload(forResponseObjectsCount objCount:Int)//可选
    {
        self.tableviewWillReloadDefault(forResponseObjectsCount: objCount)
    }
    
    func refreshDidSucceed()//可选
    {
        NSLog("refreshDidSucceed should over ride in subclasses");
    }
    
    func anotherNetWorking()//可选
    {
        NSLog("anotherNetWorking should over ride in subclasses");
    }
    
    // tableviewWillReload(forResponseObjectsCount objCount:Int)这个方法的默认操作，可供子孙类调用
    func tableviewWillReloadDefault(forResponseObjectsCount objCount:Int)
    {
        //默认操作
        if self.page == 0 && objCount == 0
        {//无内容
            self.lastCell.status = LastCellStatus.Empty
        }else if objCount == 0 || (self.page == 0 && objCount < 20)
        {//已请求不到内容，或请求到的内容不够第一页20条
            self.lastCell.status = LastCellStatus.Finished
        }else
        {//还有更多内容可加载
            self.lastCell.status = LastCellStatus.More
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.objects.count
    }

    // MARK: 自动刷新
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.needAutoRefresh
        {
            let currentTime = NSDate()
            let lastRefreshTime = self.tableView.mj_header.lastUpdatedTime
            if currentTime.timeIntervalSinceDate(lastRefreshTime) > self.refreshInterval
            {
                NSUserDefaults.standardUserDefaults().setObject(currentTime, forKey: self.tableView.mj_header.lastUpdatedTimeKey)
                NSUserDefaults.standardUserDefaults().synchronize()
                self.refresh()
            }
        }
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
