//
//  ZPSideMenuViewController.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/6.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

class ZPSideMenuViewController: UITableViewController {

    
    @IBOutlet var headerView: UIView!
    @IBOutlet var portraitView: CirclePortrait!
    @IBOutlet var nameLabel: UILabel!
    
    func testLogOut()
    {
        Config.clearProfile()
        dispatch_async(dispatch_get_main_queue()) { [unowned self] () -> Void in
            self.reloadHeaderView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadHeaderView()
        
        let leftMargin = UIScreen.mainScreen().bounds.size.width / 4 - 15
        self.headerView.addConstraintsWithVisualFormat("|-x-[portraitView]", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: ["x":leftMargin], views: ["portraitView":portraitView])

        self.portraitView.addTapAction(noLogin: self.pushLoginVC, hasLogin: self.testLogOut)
        self.nameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "pushLoginVC"))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload", name: "userRefresh", object: nil) //当登录状态改变时会触发该函数
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadHeaderView()
    {
        let user = Config.getMyProfile()
        
        if user != nil
        {
            self.portraitView.loadPortrait(user.portraitURL)
            self.nameLabel.text = user.name
        }else
        {
            self.portraitView.image = UIImage(named: "default-portrait")
            self.nameLabel.text = "点击头像登录"
        }
        
        self.nameLabel.textColor = UIColor.userNameColor()
        
    }
    
    func setContentVC(vc:UIViewController)
    {
        vc.hidesBottomBarWhenPushed = true
        let nav = (self.sideMenuViewController.contentViewController as! UITabBarController).selectedViewController as! UINavigationController
        
        nav.pushViewController(vc, animated: false)
        
        self.sideMenuViewController.hideMenuViewController()
    }
    
    func pushLoginVC()
    {
        let user = Config.getMyProfile()
        if user == nil
        {
            let loginSB = UIStoryboard(name: "Login", bundle: nil)
            let loginVC = loginSB.instantiateViewControllerWithIdentifier("LoginVC")
            self.setContentVC(loginVC)
        }
        
        
    }
    
    func reload()
    {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.reloadHeaderView()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
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
