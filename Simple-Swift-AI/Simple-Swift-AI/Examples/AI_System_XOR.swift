//
//  AI_System_XOR.swift
//  Simple-Swift-AI
//
//  Created by Arjun Gupta on 9/23/16.
//  Copyright © 2016 ArjunGupta. All rights reserved.
//

import Foundation
import UIKit

class AI_System_XOR {
    
    init(rootVC:UIViewController?) {
        
        //Building a large training set using the same four Input and Outputs of XOR Gate
        
        var trainingSet:[(input:[Double],output:[Double])] =
            [
                ([0, 0], [0]),
                ([0, 1], [1]),
                ([1, 0], [1]),
                ([1, 1], [0])
            ]
        
        for _ in stride(from: 0, to: 70000, by: 1) {
            let randomIndex = Int(arc4random_uniform(4))
            trainingSet.append(trainingSet[randomIndex])
        }
        
        let network = AutoNetworkBuilder().buildAutoNetwork(trainingSet: trainingSet, rootVC: rootVC)
        
        network.trainNetwork(trainingSets: trainingSet) { (completion) in
            
            //Test your inputs here
            
            if (completion.0 == true) {
                DebugLog("Test output -> 0 1 1 0")
                let _ = network.getOutputFor(inputs: [[0 , 0],[0 , 1],[1 , 0],[1 , 1]])
            }
        }
    }
}
