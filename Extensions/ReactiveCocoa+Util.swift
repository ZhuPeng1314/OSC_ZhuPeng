//
//  ReactiveCocoa+Util.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/12/3.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ReactiveCocoa_Util: NSObject {

}

public struct RAC  {
    var target : NSObject!
    var keyPath : String!
    var nilValue : AnyObject!
    
    init(_ target: NSObject!, _ keyPath: String, nilValue: AnyObject? = nil) {
        self.target = target
        self.keyPath = keyPath
        self.nilValue = nilValue
    }
    
    func assignSignal(signal : RACSignal) {
        signal.setKeyPath(self.keyPath, onObject: self.target, nilValue: self.nilValue)
    }
}

public func RACObserve(target: NSObject!, keyPath: String) -> RACSignal  {
    return target.rac_valuesForKeyPath(keyPath, observer: target)
}

public func <= (rac:RAC, signal:RACSignal){
    rac.assignSignal(signal)
}

public func >=( signal:RACSignal, rac:RAC){
    rac.assignSignal(signal)
}