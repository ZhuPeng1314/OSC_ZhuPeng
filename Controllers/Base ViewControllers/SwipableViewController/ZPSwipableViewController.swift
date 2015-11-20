//
//  ZPSwipableViewController.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/7.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

class ZPSwipableViewController: UIViewController,ZPTitleBarViewDelegate,ZPHorizontalTableViewControllerDelegate {
    
    var viewPage:ZPHorizontalTableViewController!
    var titleBar:ZPTitleBarView!
    
    init(title:String?, subTitles:Array<String>?, controllers:Array<UIViewController>?, underTabBar:Bool = true)
    {
        super.init(nibName: nil, bundle: nil)
        self.edgesForExtendedLayout = UIRectEdge.None //这句使得navigationController中的vc的内容会自动下移，不会被navBar挡住
        
        if title != nil
        {
            self.title = title!
        }
        
        let titleBarHeight:CGFloat = 36.0
        if subTitles != nil
        {
            self.titleBar = ZPTitleBarView(frame: CGRectMake(0, 0, self.view.bounds.size.width, titleBarHeight), titles: subTitles!)
            self.titleBar.delegate = self
            self.view.addSubview(titleBar)
        }
        
        if controllers != nil
        {
            self.viewPage = ZPHorizontalTableViewController(viewControllers: controllers!)
            self.viewPage.delegate = self
            let viewPageHeight = self.view.bounds.size.height - titleBarHeight - (underTabBar ? 0 : 49)
            self.viewPage.view.frame = CGRectMake(0, titleBarHeight, self.view.bounds.size.width, viewPageHeight)
            self.addChildViewController(viewPage)
            self.view.addSubview(viewPage.view)
        }
        
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - 实现ZPTitleBarViewDelegate
    func titleBarView(clickedTitleButtonIndex clickedTitleButtonIndex: Int) {
        //点击了titleBar上的titleButton，触发的事件
        if self.viewPage == nil || self.viewPage.controllers == nil || clickedTitleButtonIndex >= self.viewPage.controllers.count {return} //防止vc数目少于title数目的情况导致异常，可以注释该行
        self.viewPage.scrollToViewAtIndex(clickedTitleButtonIndex)
    }
    
    // MARK: - 实现ZPHorizontalTableViewControllerDelegate
    func changeViewToIndex(toIndex:Int)
    {
        let selectedTitleButton = self.titleBar.titleButtons[toIndex] as! UIButton
        self.titleBar.changeTitleHighlight(selectedTitleButton)//只改变titleBar的高亮UI，不触发事件
        self.viewPage.scrollToViewAtIndex(toIndex)
    }
    
    
    /*
    水平tableview滑动一格的过程中，offesetRatio是往返变化的，而toIndex和fromIndex在offesetRatio＝0.5时会交换，所以对于某个实际的参与动画的index来说，它的offesetRatio的变化的单调递增或者单调递减的。
    具体说明参考ZPHorizontalTableViewController.swift的func scrolling(didEndScrolling didEndScrolling:Bool)
    */
    func scrollTitleBarAnimation(offesetRatio:CGFloat, toIndex:Int, fromIndex:Int)
    {
        let titleFrom = self.titleBar.titleButtons[fromIndex] as! UIButton
        let titleTo = self.titleBar.titleButtons[toIndex] as! UIButton
        let colorValue = CGFloat(0x90) / CGFloat(0xFF)
        
        //假定offeset单调递增
        //titleFrom 变小，颜色值变大
        UIView.transitionWithView(titleFrom, duration: 0.1, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            titleFrom.setTitleColor(UIColor(red: colorValue * offesetRatio, green: colorValue, blue: colorValue * offesetRatio, alpha: 1.0), forState: UIControlState.Normal)
            titleFrom.transform = CGAffineTransformMakeScale(1 + 0.2 * (1-offesetRatio), 1 + 0.2 * (1-offesetRatio))
            }, completion: nil)
        
        //titleTo 变大，颜色值变小
        UIView.transitionWithView(titleTo, duration: 0.1, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            titleTo.setTitleColor(UIColor(red: colorValue * (1-offesetRatio), green: colorValue, blue: colorValue * (1-offesetRatio), alpha: 1.0), forState: UIControlState.Normal)
            titleTo.transform = CGAffineTransformMakeScale(1 + 0.2 * offesetRatio, 1 + 0.2 * offesetRatio)
            }, completion: nil)
    }
    
    /*optional func viewDidAppearAfterHorizontalScrolling(index:Int)
    {
    }
    
    optional func viewDidHorizontalScrolling()
    {
    }*/
    

}
