//
//  AutoNetworkBuilder.swift
//  Simple-Swift-AI
//
//  Created by Arjun Gupta on 9/23/16.
//  Copyright © 2016 ArjunGupta. All rights reserved.
//

//******************************************************************************
//
// - This class is a quick and simple way to train and test a network.
// - It checks the number of inputs and outputs of the training set to select
//   the number of neurons in Input, Hidden and Output layers.
// - Follow the code below when making a custom network
//
//******************************************************************************

import Foundation
import UIKit

class AutoNetworkBuilder {
    
    var aNetwork:NetworkA?
    
    func buildAutoNetwork(trainingSet:[(input:[Double],output:[Double])], rootVC:UIViewController? = nil) -> NetworkA {
        
        let network             = NetworkA(rootVC:rootVC)
        self.aNetwork           = network
        network.learningRate    = 0.5
        
        let infoSet                 = trainingSet[0]
        
        //Input layer
        for i in stride(from:0, to:infoSet.input.count, by:1) {
            
            let identifier  = "I" + String(i)
            let neuron      = NeuronA(uid:identifier)
            network.insert(neuron: neuron, layerNum: 0)
        }
        
        //Hidden layer
        for i in stride(from:0, to:infoSet.input.count * 3, by:1) {
            
            let identifier  = "H1-" + String(i)
            let neuron      = NeuronA(uid: identifier, bias: 0.35)
            network.insert(neuron: neuron, layerNum: 1)
        }
        
        //Output layer
        for i in stride(from:0, to:infoSet.output.count, by:1) {
            
            let identifier  = "O" + String(i)
            let neuron      = NeuronA(uid:identifier, bias: 0.6)
            network.insert(neuron: neuron, layerNum: 2)
        }
        
        network.connectNeuronsWithRandomizedWeights()
        
        return network
    }
}

