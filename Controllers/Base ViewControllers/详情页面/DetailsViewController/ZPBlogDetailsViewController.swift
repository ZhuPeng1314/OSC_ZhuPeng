//
//  ZPBlogDetailsViewController.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/16.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import TBXML

class ZPBlogDetailsViewController: ZPDetailsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func initData(id: String) {
        self.navigationItem.title = "博客详情"
        self.detailsURLString = "\(OSCAPI_PREFIX)\(OSCAPI_BLOG_DETAIL)?id=\(id)"
        self.tag = "blog"
        self.commentType = CommentType.Blog
        self.favoriteType = FavoriteType.Blog
    }
    
    override func loadDetails(details: ZPOSCDetails!) {
        super.loadDetails(details)
        if let details1 = details as? ZPOSCBlogDetails
        {
            
        }
    }
    
    override func loadDetailsFromXML(xml: UnsafeMutablePointer<TBXMLElement>) -> ZPOSCDetails! {
        return ZPOSCBlogDetails(element: xml)
    }

}
