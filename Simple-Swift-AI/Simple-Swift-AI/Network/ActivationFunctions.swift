//
//  ActivationFunctions.swift
//  Simple-Swift-AI
//
//  Created by Arjun Gupta on 7/29/16.
//  Copyright © 2016 ArjunGupta. All rights reserved.
//

import Foundation

class ActivationFunctions {
    
    
    class func linear(x: Double) -> Double {
        return x
    }
    
    class func sigmoid(val: Double) -> Double {
        return 1 / (1 + exp(-val))
    }
    
    
}
