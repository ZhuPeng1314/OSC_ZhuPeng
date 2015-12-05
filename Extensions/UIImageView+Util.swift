//
//  UIImageView+Util.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/12/5.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

extension UIImageView {

    /*
    func loadPortrait(tweet:ZPOSCTweet)
    {
        if tweet.portraitURL != nil
        {
            if tweet.portraitImage == nil
            {
                tweet.portraitImage = UIImage(named: "default-portrait")
                downloadImageThenReload(tweet)
            }
        }else{
            tweet.portraitImage = UIImage(named: "default-portrait")
        }
    }
    
    func downloadImageThenReload(tweet:ZPOSCTweet)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            if let data = NSData(contentsOfURL: tweet.portraitURL)
            {
                let image = UIImage(data: data)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    tweet.portraitImage = image
                    self.tableView.reloadData()
                })
                
            }else
            {
                print("Download Image failed: \(tweet.portraitURL.absoluteString)")
            }
        }
    }*/
    
    func asyncLoadImage(imageURL:NSURL!, defaultImageName:String, reloadBlock:(UIImage!)->Void)
    {
        self.image = UIImage(named: defaultImageName)
        if imageURL != nil
        {
            downloadImageThenReload(imageURL, reloadBlock: reloadBlock)
        }
    }
    
    func downloadImageThenReload(imageURL:NSURL!, reloadBlock:(UIImage!)->Void)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            if let data = NSData(contentsOfURL: imageURL)
            {
                let image = UIImage(data: data)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    reloadBlock(image)
                })
                
            }else
            {
                print("下载图片失败 Download Image failed: \(imageURL.absoluteString)")
            }
        }
    }
    
    

}






