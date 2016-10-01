//
//  Utils.swift
//  Simple-Swift-AI
//
//  Created by Arjun Gupta on 7/29/16.
//  Copyright © 2016 ArjunGupta. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
}

func DebugLog(_ logMessage: String, className: String = #file, lineNumber: NSInteger = #line) {
    let tempArr = className.characters.split(separator: "/").map(String.init)
    let last    = tempArr[tempArr.count-1]
    print("\(last) ... Line: \(lineNumber) ... \(logMessage)", terminator: "\n")
}


extension Double {
    
    func roundToDigits(digits:Int) -> Double {
        let divisor = pow(10.0, Double(digits))
        return (self * divisor).rounded() / divisor
    }
}
