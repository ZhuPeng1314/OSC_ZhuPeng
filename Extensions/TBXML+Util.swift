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
    
    // MARK:- CurrentElement
    private struct CurrentElement {
        static var currentElementLock:NSLock!
        static var currentElement:UnsafeMutablePointer<TBXMLElement> = nil
    }
    
    static func setCurrentElement(element:UnsafeMutablePointer<TBXMLElement>)
    {
        if (CurrentElement.currentElementLock == nil)
        {
            CurrentElement.currentElementLock = NSLock()
        }
        CurrentElement.currentElementLock.lock()
        CurrentElement.currentElement = element
    }
    
    static func releaseCurrentElement()
    {
        CurrentElement.currentElementLock.unlock()
    }
    
    // MARK:- String
    
    static func stringFromCurrentElement(forNames names:Array<String>)->String!
    {
        return TBXML.stringForElementNames(names, parentElement: CurrentElement.currentElement)
    }
    
    static func stringForElementNames(names:Array<String>, parentElement:UnsafeMutablePointer<TBXMLElement>)->String!
    {
        var node:UnsafeMutablePointer<TBXMLElement> = nil
        for var i = 0; i < names.count; i++
        {
            node = TBXML.childElementNamed(names[0], parentElement: parentElement)
            if node != nil
            {
                break
            }
        }
        if node != nil
        {
            return TBXML.textForElement(node)
        }
        return nil
    }
    
    static func stringFromCurrentElement(forNamed name:String)->String!
    {
        return TBXML.stringForElementNamed(name, parentElement: CurrentElement.currentElement)
    }
    
    static func stringForElementNamed(name:String, parentElement:UnsafeMutablePointer<TBXMLElement>)->String!
    {
        let node = TBXML.childElementNamed(name, parentElement: parentElement)
        if node != nil
        {
            return TBXML.textForElement(node)
        }
        return nil
    }
    
    // MARK:- URL
    
    static func URLFromCurrentElement(forNamed name:String)->NSURL!
    {
        return TBXML.URLForElementNamed(name, parentElement: CurrentElement.currentElement)
    }
    
    static func URLForElementNamed(name:String, parentElement:UnsafeMutablePointer<TBXMLElement>)->NSURL!
    {
        if let urlString = TBXML.stringForElementNamed(name, parentElement: parentElement)
        {
            if (urlString as NSString).isEqualToString("")
            {
                return nil
            }
            return NSURL(string: urlString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
        }
        return nil
        
    }
    
    // MARK:- Int
    
    static func intValueFromCurrentElement(forNamed name:String)->Int!
    {
        return TBXML.intValueForElementNamed(name, parentElement: CurrentElement.currentElement)
    }
    
    static func intValueForElementNamed(name:String, parentElement:UnsafeMutablePointer<TBXMLElement>)->Int!
    {
        if let intValueString = TBXML.stringForElementNamed(name, parentElement: parentElement)
        {
            return Int(intValueString)
        }
        return nil
    }
    
    // MARK:- Bool
    
    static func boolValueFromCurrentElement(forNamed name:String)->Bool!
    {
        return TBXML.boolValueForElementNamed(name, parentElement: CurrentElement.currentElement)
    }
    
    static func boolValueForElementNamed(name:String, parentElement:UnsafeMutablePointer<TBXMLElement>)->Bool!
    {
        if let boolValueString = TBXML.stringForElementNamed(name, parentElement: parentElement)
        {
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            return formatter.numberFromString(boolValueString)?.boolValue
        }
        return nil
    }
    
    // MARK:- Date
    
    static func dateFromCurrentElement(forNamed name:String)->NSDate!
    {
        return TBXML.dateForElementNamed(name, parentElement: CurrentElement.currentElement)
    }
    
    static func dateForElementNamed(name:String, parentElement:UnsafeMutablePointer<TBXMLElement>)->NSDate!
    {
        
        if let dateString = TBXML.stringForElementNamed(name, parentElement: parentElement)
        {
            return NSDate.dateFromString(dateString)
        }
        return nil
    }
    
    // MARK:- 获得TBXML对象
    
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




