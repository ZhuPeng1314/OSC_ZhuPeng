//
//  UIImageView+Util.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/12/5.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

extension UIImageView {
    
    // MARK:- 不带存储Block的异步加载
    
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
    
    
    // MARK:- 全局存储已经下载好的图片
    struct DownloadedImages {
        static var collection = [String:UIImage]()
    }
    
    // MARK:- 带存储Block的异步加载
    
    /* storeBlock样例
    func storeBlock(x:UIImage!)->UIImage!
    {
        if x != nil
        {
            a.image = x
        }
        return self.image
    }
    */
    
    static func hasDownloaded(imageURL:NSURL!)->UIImage!
    {
        return UIImageView.DownloadedImages.collection[imageURL.absoluteString]
    }
    
    //成员方法，将异步加载好的图片显示在self中
    func asyncLoadImage(imageURL:NSURL!, defaultImageName:String, reloadBlock:(UIImage!)->Void, storeBlock:(UIImage!)->UIImage!)
    {
        if let storage = storeBlock(nil)
        {
            self.image = storage
            return
        }
        
        if let storage2 = UIImageView.hasDownloaded(imageURL)
        {
            self.image = storage2
            storeBlock(storage2)
            return
        }
        
        self.image = UIImage(named: defaultImageName)
        UIImageView.downloadImageThenReload(imageURL, reloadBlock: reloadBlock, storeBlock: storeBlock)
        
    }
    
    //静态方法，异步加载图片，加载好后利用存储block存储，利用reloadBlock刷新UI显示
    static func asyncLoadImage(imageURL:NSURL!, reloadBlock:(UIImage!)->Void, storeBlock:(UIImage!)->UIImage!)
    {
        if imageURL == nil
        {
            return
        }
        
        if let imageDownloaded = UIImageView.hasDownloaded(imageURL)
        {
            storeBlock(imageDownloaded)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                reloadBlock(imageDownloaded)
            })
        }else
        {
            UIImageView.downloadImageThenReload(imageURL, reloadBlock: reloadBlock, storeBlock: storeBlock)
        }

    }
    
    private static func downloadImageThenReload(imageURL:NSURL!, reloadBlock:(UIImage!)->Void, storeBlock:(UIImage!)->UIImage!)
    {
        if imageURL == nil
        {
            return
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            if let data = NSData(contentsOfURL: imageURL)
            {
                let image = UIImage(data: data)
                UIImageView.DownloadedImages.collection[imageURL.absoluteString] = image
                storeBlock(image)
                
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






