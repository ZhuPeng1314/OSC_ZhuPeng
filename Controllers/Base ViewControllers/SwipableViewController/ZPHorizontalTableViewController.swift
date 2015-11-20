//
//  ZPHorizontalTableViewController.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/8.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

@objc protocol ZPHorizontalTableViewControllerDelegate:NSObjectProtocol
{
    func changeViewToIndex(toIndex:Int)
    func scrollTitleBarAnimation(offesetRatio:CGFloat, toIndex:Int, fromIndex:Int)
    optional func viewDidAppearAfterHorizontalScrolling(index:Int)
    optional func viewDidHorizontalScrolling()
}

class ZPHorizontalTableViewController: UITableViewController {
    
    var controllers:NSMutableArray!
    var currentIndex:Int = 0
    weak var delegate:ZPHorizontalTableViewControllerDelegate?
    
    init(viewControllers:Array<UIViewController>)
    {
        super.init(style: UITableViewStyle.Plain)
        self.controllers = NSMutableArray(array: viewControllers)
        for controller in viewControllers
        {
            self.addChildViewController(controller)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.scrollsToTop = false
        self.tableView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))//整个表逆时针旋转90度
        self.tableView.bounces = false
        self.tableView.pagingEnabled = true
        self.tableView.showsVerticalScrollIndicator = false
        //self.tableView.backgroundColor
        
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.tableView.frame.size.width
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.controllers.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kHorizontalCellID = "HorizontalCell"
        var newCell = tableView.dequeueReusableCellWithIdentifier(kHorizontalCellID)
        if newCell == nil
        {
            newCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: kHorizontalCellID)
            newCell?.contentView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))//单元格内容顺时针旋转90度，中和表格的旋转
            //cell?.contentView.backgroundColor
            newCell?.selectionStyle = UITableViewCellSelectionStyle.None
        }

        let cell = newCell!
        let controller = self.controllers[indexPath.row] as! UIViewController
        controller.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(controller.view)

        return cell
    }
    

    
    
    // MARK: - 横向滚动切换页面 相关
    
    // 根据index，直接切换页面，无动画
    func scrollToViewAtIndex(index:Int)
    {
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition: UITableViewScrollPosition.None, animated: false)
        self.currentIndex = index
        
        if self.delegate?.viewDidAppearAfterHorizontalScrolling != nil
        {
            self.delegate?.viewDidAppearAfterHorizontalScrolling!(index)
        }
        
    }
    
    //滑动过程中进行的处理
    //包括 正在滑动 和 滑动停止时 两部分的操作
    func scrolling(didEndScrolling didEndScrolling:Bool)
    {
        let horizontalOffset = self.tableView.contentOffset.y // HorizontalOffset ＝ 页数＊宽度 ＋ 横向滑动距离
        let screenWidth = self.tableView.frame.size.width //表格的旋转矩阵并不会直接改变frame的方向
        let focusIndex = Int((horizontalOffset + screenWidth / 2) / screenWidth) //滑动过半页的时候focusIndex会改变
        
        
        if didEndScrolling == true
        {//滑动停止，改变当前的焦点页面
            self.delegate?.changeViewToIndex(focusIndex)
        }else
        {//滑动过程中
            //当HorizontalOffset ＝＝ focusIndex * screenWidth 同时 focusIndex ＝＝ 0，willToIndex应该为1而不是－1
            //与此同时，当HorizontalOffset ＝＝ focusIndex * screenWidth时，刚好是滑动到整页的瞬间，无需再执行动画,故此过滤掉
            if (horizontalOffset != CGFloat(focusIndex) * screenWidth)
            {
                let willToIndex = (horizontalOffset < CGFloat(focusIndex) * screenWidth) ? focusIndex - 1 : focusIndex + 1
                var offsetRatio = CGFloat(Int(horizontalOffset) % Int(screenWidth)) / CGFloat(screenWidth)
                if focusIndex > willToIndex
                {//向左滑动 或者 滑动过半的时候， 滑动率向反方向变化
                    offsetRatio = 1 - offsetRatio
                    /* e.g. 假如向右划，前半部分，滑动率递增，from（按钮1）会变小，to（按钮2）变大
                    （后半部分 fromIndex和toIndex实际值交换了）向右划，后半部分，滑动率递减，from（按钮2）变大，to（按钮1）变小
                    所以全程按钮1变小，按钮2变大
                    如果在过程中HorizontalOffset的变化方向改变，则变化率的方向也会改变。*/
                }
                self.delegate?.scrollTitleBarAnimation(offsetRatio, toIndex: willToIndex, fromIndex: focusIndex)
            }
        }
    }
    
    
    //手指滑动结束并且view的滑动动画减速到停止时调用
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrolling(didEndScrolling: true)
    }
    
    //正在滑动的过程中，滑动动画未停止时调用
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.scrolling(didEndScrolling: false)
        
        if self.delegate?.viewDidHorizontalScrolling != nil
        {
            self.delegate?.viewDidHorizontalScrolling!()
        }
    }
    
    
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
