//
//  TBXML+Util.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/20.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import TBXML

extension TBXML {
    
    static func stringForElementNamed(name:String, parentElement:UnsafeMutablePointer<TBXMLElement>)->String!
    {
        let node = TBXML.childElementNamed(name, parentElement: parentElement)
        if node != nil
        {
            return TBXML.textForElement(node)
        }
        return nil
    }
    
    static func URLForElementNamed(name:String, parentElement:UnsafeMutablePointer<TBXMLElement>)->NSURL!
    {
        if let urlString = TBXML.stringForElementNamed(name, parentElement: parentElement)
        {
            return NSURL(string: urlString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
        }
        return nil
        
    }
    
    static func intValueForElementNamed(name:String, parentElement:UnsafeMutablePointer<TBXMLElement>)->Int!
    {
        if let intValueString = TBXML.stringForElementNamed(name, parentElement: parentElement)
        {
            return Int(intValueString)
        }
        return nil
    }
    
    static func dateForElementNamed(name:String, parentElement:UnsafeMutablePointer<TBXMLElement>)->NSDate!
    {
        
        if let dateString = TBXML.stringForElementNamed(name, parentElement: parentElement)
        {
            return NSDate.dateFromString(dateString)
        }
        return nil
    }
    
    static func getXMLFromStringData(dataString:NSString)->TBXML!
    {
        var XML:TBXML!
        do{
            XML = try TBXML(XMLString: dataString as String, error: ())
            
        }catch{
            print(error)
        }
        return XML
    }
    
    static func getXMLFromUTF8Data(data:NSData)->TBXML!
    {
        let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
        return TBXML.getXMLFromStringData(dataString!)
    }
    
    

}




