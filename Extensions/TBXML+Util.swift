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
        return TBXML.textForElement(TBXML.childElementNamed(name, parentElement: parentElement))
    }
    
    static func getRootElementFromStringData(dataString:NSString)->TBXML!
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
        return TBXML.getRootElementFromStringData(dataString!)
    }

}




