//
//  InputA.swift
//  Simple-Swift-AI
//
//  Created by Arjun Gupta on 7/29/16.
//  Copyright © 2016 ArjunGupta. All rights reserved.
//

import Foundation
import UIKit

@objc class InputA:NSObject {
    
    var weight  :Double
    var neuron  :NeuronA?
    var value   :Double? {
        set (newValue) { self.valueStore = newValue }
        get { return (self.neuron != nil) ? self.neuron!.output! : self.valueStore }
    }
    private var valueStore:Double?
    var indexInLayer:Int = 0
    
    //Input layer
    init(value:Double, weight:Double) {
        self.weight = weight
        super.init()
        self.value  = value
    }
    
    //Hidden layer
    init(neuron:NeuronA, weight:Double) {
        self.neuron = neuron
        self.weight = weight
    }
}
