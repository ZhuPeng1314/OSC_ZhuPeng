//
//  ZPSoftwareDetailsViewController.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/16.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import TBXML

class ZPSoftwareDetailsViewController: ZPDetailsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func initData(id: String) {
        
        self.navigationItem.title = "软件详情"
        self.detailsURLString = "\(OSCAPI_PREFIX)\(OSCAPI_SOFTWARE_DETAIL)?ident=\(id)"
        self.tag = "software"
        self.commentType = CommentType.Software
        self.favoriteType = FavoriteType.Software
    }
    
    override func loadDetails(details: ZPOSCDetails!) {
        super.loadDetails(details)
        if let details1 = details as? ZPOSCSoftwareDetails
        {
            
        }
    }
    
    override func loadDetailsFromXML(xml: UnsafeMutablePointer<TBXMLElement>) -> ZPOSCDetails! {
        return ZPOSCSoftwareDetails(element: xml)
    }
    
    

}
