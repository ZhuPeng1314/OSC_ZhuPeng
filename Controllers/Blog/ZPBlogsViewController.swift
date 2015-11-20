//
//  ZPBlogsViewController.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/7.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import Ono

enum BlogsType:Int{
    case Latest
    case Recommended
    
}

class ZPBlogsViewController: ZPNewsViewController {
    //因为BlogsVC的界面大致于NewsVC一致，可以重用一部分代码，故继承此类

    static let kBlogCellID = "BlogCell"
    private var type:BlogsType!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init(type type1:BlogsType)
    {
        type = type1
        super.init()
        
        self.objClass = ZPOSCBlog.self
        
        //自动刷新部分
        //self.needAutoRefresh = true //默认为true
        self.refreshInterval = 7200
        self.kLastRefreshTimeKey = "BlogsRefreshInterval-\(type1)"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(ZPBlogCell.self, forCellReuseIdentifier: ZPBlogsViewController.kBlogCellID)
    }
    
    // MARK: - 重写基类的方法
    
    override func generateURL(forPage page: Int) -> String {
        let blogType = ((type == BlogsType.Latest) ? "latest" : "recommend")
        
        return "\(OSCAPI_PREFIX)\(OSCAPI_BLOGS_LIST)?type=\(blogType)&pageIndex=\(page)&\(OSCAPI_SUFFIX)"
    }
    
    override func parseXML(xml:ONOXMLDocument)->Array<ONOXMLElement>
    {
        let root = xml.rootElement as ONOXMLElement
        let blogslist = root.firstChildWithTag("blogs") as ONOXMLElement
        let blog = blogslist.childrenWithTag("blog") as! Array<ONOXMLElement>
        
        return blog
    }
    
    override func parseExtraInfo(fromDocument document:ONOXMLDocument)//可选
    {
        NSLog("parseExtraInfo should over ride in subclasses");
    }
    
    override func tableviewWillReload(forResponseObjectsCount objCount:Int)//可选
    {
        self.tableviewWillReloadDefault(forResponseObjectsCount: objCount)
    }
    
    override func refreshDidSucceed()//可选
    {
        NSLog("refreshDidSucceed should over ride in subclasses");
    }
    
    override func anotherNetWorking()//可选
    {
        NSLog("anotherNetWorking should over ride in subclasses");
    }
    

    // MARK:- 列表的显示部分都直接沿用父类的
    
    // MARK:- 选中某条Blog
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let blog = self.objects[indexPath.row] as! ZPOSCBlog
        let detailsVC = ZPBlogDetailsViewController(id: blog.id)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}



