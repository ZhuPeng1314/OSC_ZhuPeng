//
//  HomepageViewController.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/12/1.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

class HomepageViewController: UITableViewController {

    @IBOutlet var portraitView: UIImageView!
    @IBOutlet var QRcodeButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var creditButton: UIButton!
    @IBOutlet var collectionButton: UIButton!
    @IBOutlet var followingButton: UIButton!
    @IBOutlet var fansButton: UIButton!
    
    @IBOutlet var separator: UIView!
    
    var myID:String!
    var myProfile:ZPOSCUser!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userRefreshHandler:", name: "userRefresh", object: nil)
        
        //二维码相关的 暂不实现
        //[_QRCodeButton addTarget:self action:@selector(showQRCode) forControlEvents:UIControlEventTouchUpInside];
        
        self.tableView.backgroundColor = UIColor.themeColor()
        self.tableView.separatorColor = UIColor.separatorColor()
        
        setupSubviews()
        refreshHeaderView() //根据登录状态，更新homepage页面的顶部view的各部分数据
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK:- 设置子视图和控件的样式
    func setupSubviews()
    {
        setupButtonLabelFormat(creditButton)
        setupButtonLabelFormat(collectionButton)
        setupButtonLabelFormat(followingButton)
        setupButtonLabelFormat(fansButton)
        
        self.portraitView.setBorderWidth(2.0, color: UIColor.whiteColor())
        self.portraitView.setCornerRadius(25.0)
        
        self.setCoverImage()
        
        self.refreshControl?.tintColor = UIColor.refreshControlColor()
    }
    
    private func setupButtonLabelFormat(button:UIButton)
    {
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = NSTextAlignment.Center
    }
    
    func setCoverImage()
    {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        var imageName = "user-background"
        
        if screenWidth < 400
        {
            imageName = "\(imageName)-\(screenWidth)"
        }
        
        if (UIApplication.sharedApplication().delegate as! AppDelegate).inNightMode
        {
            imageName = "\(imageName)-dark"
        }
        
        if self.tableView.scalableCover == nil
        {
            self.tableView.addScalableCoverWithImage(UIImage(named: imageName))
        }else
        {//应该在切换夜晚模式的时候调用，有待测试
            self.tableView.scalableCover?.image = UIImage(named: imageName)
        }
    }

    // MARK:- 点击头像事件
    @IBAction func tapPortrait()
    {
        if NetworkStatusUtils.isNoNetworkWithHUD() == false //如果无网络会显示1秒钟HUD提示
        {
            if Config.getOwnID() == nil //未登录
            {
                pushLoginVC()//显示登录界面
            }else{
            
                //显示用户详情
            }
        }
        
    }
    
    // MARK: - 弹出登录界面
    private func pushLoginVC()
    {
        
        let loginSB = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = loginSB.instantiateViewControllerWithIdentifier("LoginVC")
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    // MARK: - 登录成功
    
    func userRefreshHandler(notification:NSNotification)
    {
        refreshHeaderView() // 更新homepage页面的顶部view的各部分数据
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
        }
        
    }
    
    // 更新homepage页面的顶部view的各部分数据
    func refreshHeaderView()
    {
        self.myProfile = Config.getMyProfile()
        let isLogin = (myProfile != nil)
        
        if isLogin
        {
            self.myID = myProfile.id
            self.portraitView.asyncLoadImage(myProfile.portraitURL, defaultImageName: "default-portrait", reloadBlock: { (newPortrait) -> Void in
                self.portraitView.image = newPortrait
            })
            self.nameLabel.text = myProfile.name
            
            //tweet相关的 暂不实现
            
        }else {
            self.portraitView.image = UIImage(named: "default-portrait")
            self.nameLabel.text = "点击头像登录" //没登录时显示 “点击头像登录”
        }
        
        creditButton.hidden = !isLogin
        collectionButton.hidden = !isLogin
        followingButton.hidden = !isLogin
        fansButton.hidden = !isLogin
        QRcodeButton.hidden = !isLogin
        separator.hidden = !isLogin
        
        if isLogin
        {
            self.separator.backgroundColor = UIColor.lineColor()
            creditButton.setTitle("积分\n\(myProfile.score)", forState: UIControlState.Normal)
            collectionButton.setTitle("收藏\n\(myProfile.favoriteCount)", forState: UIControlState.Normal)
            followingButton.setTitle("关注\n\(myProfile.followersCount)", forState: UIControlState.Normal)
            fansButton.setTitle("粉丝\n\(myProfile.fansCount)", forState: UIControlState.Normal)
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
