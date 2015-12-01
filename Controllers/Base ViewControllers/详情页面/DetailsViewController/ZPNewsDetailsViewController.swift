//
//  ZPNewsDetailsViewController.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/16.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import TBXML

class ZPNewsDetailsViewController: ZPDetailsViewController {
    
    static func createDetailsVC(news:ZPOSCNews)->ZPDetailsViewController
    {
        switch (news.type!)
        {
        case .StandardNews: return ZPNewsDetailsViewController(id: news.id)
        case .SoftWare: return ZPSoftwareDetailsViewController(id: news.attachment)
        case .QA: return ZPPostDetailsViewController(id: news.attachment)
        case .Blog: return ZPBlogDetailsViewController(id: news.attachment)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func initData(id: String) {
        self.navigationItem.title = "资讯详情"
        self.detailsURLString = "\(OSCAPI_PREFIX)\(OSCAPI_NEWS_DETAIL)?id=\(id)"
        self.tag = "news"
        self.commentType = CommentType.News
        self.favoriteType = FavoriteType.News
    }
    
    override func loadDetails(details: ZPOSCDetails!) {
        super.loadDetails(details)
        if let details1 = details as? ZPOSCNewsDetails
        {
            
        }
    }
    
    override func loadDetailsFromXML(xml: UnsafeMutablePointer<TBXMLElement>) -> ZPOSCDetails! {
        return ZPOSCNewsDetails(element: xml)
    }
    
    
}
