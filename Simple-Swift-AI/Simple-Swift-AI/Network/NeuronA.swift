//
//  NeuronA.swift
//  Simple-Swift-AI
//
//  Created by Arjun Gupta on 7/29/16.
//  Copyright © 2016 ArjunGupta. All rights reserved.
//

import Foundation
import UIKit

@objc class NeuronA:NSObject {
    
    var identifier  :String
    var inputs      = [String:InputA]()
    var bias        :Double?
    var output      :Double?
    var error       :Double?
    
    //Input Neuron
    init(uid:String) {
        self.identifier = uid
    }
    
    //Hidden Neuron
    init(uid:String, bias:Double , inputs:[InputA]? = nil) {
        self.identifier  = uid
        self.bias        = bias
        super.init()
        if let theInputs = inputs {
            self.attachInputs(inputs: theInputs)
            self.calculateOutput()
        }
    }
    
    func attachInputs(inputs:[InputA]) {
        for input in inputs {
            self.inputs[input.neuron!.identifier] = input
        }
    }
    
    func calculateOutput() {
        
        if (self.inputs.keys.count == 0) { return }
        
        var inputWeightSummation:Double = 0
        for input in self.inputs.values {
            inputWeightSummation += (input.value! * input.weight)
        }
        
        let net     = inputWeightSummation + self.bias!
        self.output  = ActivationFunctions.sigmoid(val:net)
    }
}
