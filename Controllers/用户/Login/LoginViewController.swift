//
//  LoginViewController.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/12/2.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import ReactiveCocoa
import MBProgressHUD
import AFNetworking
import TBXML

class LoginViewController: UIViewController {
    
    @IBOutlet var accountField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    var hud:MBProgressHUD!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.themeColor()
        prefillAccountAndPassword() //预填充账号密码
        
        let valid = RACSignal.combineLatest([accountField.rac_textSignal(), passwordField.rac_textSignal()]) { [unowned self] () -> AnyObject! in
            let account = self.accountField.text! as NSString
            let password = self.passwordField.text! as NSString
            return (account.length > 0 && password.length > 0)
        }
        
        RAC(loginButton, "enabled") <= valid
        RAC(loginButton, "alpha") <= valid.map({ (isValid) -> AnyObject! in
            return ((isValid as! Bool) ? 1.0 : 0.4)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if hud != nil
        {
            self.hud.hide(animated)
        }
    }

    // MARK: - 预填充账号密码
    func prefillAccountAndPassword()
    {
        let data = Config.getOwnAccountAndPassword()
        if data != nil
        {
            self.accountField.text = data[0]
            self.passwordField.text = data[1]
        }
    }
    
    // MARK: - Login
    
    @IBAction func login()
    {
        self.hud = MBProgressHUDUtils.createHUD()
        hud.labelText = "正在登录"
        hud.userInteractionEnabled = false
        
        let menager = AFHTTPRequestOperationManager.OSCManager()
        
        menager.POST("\(OSCAPI_HTTPS_PREFIX)\(OSCAPI_LOGIN_VALIDATE)",
            parameters: ["username":accountField.text!,
                              "pwd":passwordField.text!,
                       "keep_login":1],
            success: { [unowned self] (operation, data) -> Void in
                //print(NSString(data: data as! NSData, encoding: NSUTF8StringEncoding))
                let tbxml = TBXML.getXMLFromUTF8Data(data as! NSData)
                let result = TBXML.childElementNamed("result", parentElement: tbxml.rootXMLElement)
                
                let errorCode = TBXML.intValueForElementNamed("errorCode", parentElement: result)
                
                if (errorCode == 0)
                {
                    let errorMSG = TBXML.stringForElementNamed("errorMessage", parentElement: result)
                    
                    MBProgressHUDUtils.setHUD(self.hud, withErrorImageName: "HUD-error", labelText: "错误：\(errorMSG)", detailText: nil)
                    self.hud.hide(true, afterDelay: 1)
                    return
                }
                
                //*********   login successfully   ******************//
                
                Config.saveOwnAccount(self.accountField.text!, password: self.passwordField.text!)
                let userXML = TBXML.childElementNamed("user", parentElement: tbxml.rootXMLElement)
                
                self.renewUserWithXML(userXML)
                
            }) { (operation, error) -> Void in
                
                MBProgressHUDUtils.setHUD(self.hud, withErrorImageName: "HUD-error",
                                                             labelText: "错误：\(operation?.response?.statusCode)",
                                                            detailText: error.userInfo[NSLocalizedDescriptionKey] as! String)
                self.hud.hide(true, afterDelay: 1)
        }
    }

    
    func renewUserWithXML(xml:UnsafeMutablePointer<TBXMLElement>)
    {
        let user = ZPOSCUser(element: xml)
        Config.saveProfile(user)
        
        //关于poll通知的功能 暂时不实现
        
        Config.saveCookies()
        
        NSNotificationCenter.defaultCenter().postNotificationName("userRefresh", object: true)
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    

}










