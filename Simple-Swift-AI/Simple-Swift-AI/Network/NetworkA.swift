//
//  NetworkA.swift
//  Simple-Swift-AI
//
//  Created by Arjun Gupta on 7/29/16.
//  Copyright © 2016 ArjunGupta. All rights reserved.
//

import Accelerate
import Foundation
import UIKit

class NetworkA {
    
    var learningRate        :Double  = 0.5
    var layers              = [[NeuronA]]()
    private var networkVC   :NetworkViewController?
    
    
    init(rootVC:UIViewController? = nil) {
        if let theRootVC = rootVC {
            self.networkVC = NetworkViewController.loadVC(rootVC:theRootVC)
        }
    }
    
    
    func insert(neuron:NeuronA, layerNum:Int) {
        if (self.layers.count <= layerNum) {
            while self.layers.count <= layerNum {
                let layer = [NeuronA]()
                self.layers.append(layer)
            }
        }
        self.layers[layerNum].append(neuron)
    }
    
    
    //Assign randomized weights to begin
    func connectNeuronsWithRandomizedWeights() {
        
        for (index,neuronLayer) in self.layers.enumerated() {
            
            if index == 0 { continue }
            
            for neuron in neuronLayer {
                var neuronInputs = [InputA]()
                
                //DebugLog("Random assigned weights for : \(neuron.identifier) -->")
                
                for (neuronIndex,prevNeuron) in self.layers[index-1].enumerated() {
                    let randomWeight:Double = Double(arc4random_uniform(15) + 45) * 0.01
                    let input = InputA(neuron: prevNeuron, weight: randomWeight)
                    input.indexInLayer = neuronIndex
                    //DebugLog("\(input.neuron?.identifier) : \(randomWeight)")
                    
                    neuronInputs.append(input)
                }
                neuron.attachInputs(inputs: neuronInputs)
            }
        }
        
        self.networkVC?.buildView(layers: self.layers, learningRate: CGFloat(self.learningRate))
    }
    
    
    func checkCompatibility(input:[Double],output:[Double]?) -> Bool {
        //Fail safe check
        
        var trainingSetCompatible = true
        if (input.count != self.layers[0].count) {
            DebugLog("ERROR: Input neuron count mismatch with training inputs. Expected \(self.layers[0].count). Got \(input.count)")
            trainingSetCompatible = false
        }
        if let theOutput = output {
            if (theOutput.count != self.layers.last!.count) {
                DebugLog("ERROR: Out neuron count mismatch with training outputs. Expected \(self.layers.last!.count) Got \(theOutput.count)")
                trainingSetCompatible = false
            }
        }
        return trainingSetCompatible
    }
    
    
    
    func trainNetwork(trainingSets:[(input:[Double],output:[Double])], completionBlock: ((Bool,CGFloat) -> Void)?) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            guard let theSelf = self else {
                DebugLog("ERROR: Self cannot be nil!")
                return
            }
            
            var currentPercentCompletion:CGFloat = 0
            
            for (ioSetIndex, ioSet) in trainingSets.enumerated() {
                
                if (theSelf.checkCompatibility(input:ioSet.input, output:ioSet.output) == false) { break }
                
                ///////DebugLog("setIndex : \(setIndex)")
                
                //MARK:- Forward pass
                for (layerIndex,layer) in theSelf.layers.enumerated() {
                    
                    for (neuronIndex,neuron) in layer.enumerated() {
                        if (layerIndex == 0) {
                            neuron.output = ioSet.input[neuronIndex]
                        }
                        else {
                            neuron.calculateOutput()
                        }
                    }
                }
                
                
                //MARK:- Output error
                /*
                var totalError:Double = 0
                for (setIndex,targetOutput) in ioSet.output.enumerated() {
                    
                    let outputLayerNeurons  = theSelf.layers.last!
                    let outputNeuron        = outputLayerNeurons[setIndex]
                    let outputError         = 0.5 * pow((targetOutput - outputNeuron.output!), 2)
                    totalError              += outputError
                 
                    //DebugLog("\(outputNeuron.identifier) output:\(outputNeuron.output!) expOutput:\(targetOutput), error : \(outputError)")
                }
                DebugLog("TotalError : \(totalError.roundToDigits(digits: 5))")
                */
                
                
                //MARK:- Backward pass
                var newWeights          = [NeuronA:[(String,Double)]]()
                var layersErrorOByNetO  = [[NeuronA:Double]]()
                var currentLayerCount   = 0
                
                for i in stride(from: theSelf.layers.count - 1, through: 1, by: -1) {
                    
                    var aLayerErrorOByNetO  = [NeuronA:Double]()
                    let alayer              = theSelf.layers[i]
                    for (neuronIndex, aNeuron) in alayer.enumerated() {
                        
                        var newInputWeights = [(String,Double)]()
                        for input in aNeuron.inputs.values {
                            
                            var deltaO:Double = 0
                            if (i == theSelf.layers.count - 1) { //Output layer
                                let targetOutput            = ioSet.output[neuronIndex]
                                let deltaErrorByNet         = -(targetOutput - aNeuron.output!) * aNeuron.output! * (1 - aNeuron.output!)
                                aLayerErrorOByNetO[aNeuron] = deltaErrorByNet
                                deltaO                      = deltaErrorByNet
                            }
                            else {
                                var deltaErrorOByNetO:Double      = 0
                                let theLayerSigmaOutputs    = layersErrorOByNetO[currentLayerCount - 1]
                                for outputNeuron in theLayerSigmaOutputs.keys {
                                    
                                    let connectedInput = outputNeuron.inputs[aNeuron.identifier]!
                                    deltaErrorOByNetO += theLayerSigmaOutputs[outputNeuron]! * connectedInput.weight
                                    
                                }
                                
                                //Store this in an array for use in deeper layers
                                aLayerErrorOByNetO[aNeuron] = deltaErrorOByNetO
                                
                                deltaErrorOByNetO           = deltaErrorOByNetO * aNeuron.output!*(1 - aNeuron.output!)
                                
                                deltaO                      = deltaErrorOByNetO
                            }
                            
                            let dTotalError_by_dOutputWeight = deltaO * input.value!
                            
                            let newWeight = input.weight - (theSelf.learningRate * dTotalError_by_dOutputWeight)
                            
                            //DebugLog("\(aNeuron.identifier) newWeight\(input.neuron?.identifier) : \(newWeight)")
                            
                            let inputWtDict                 = (input.neuron!.identifier,newWeight)
                            newInputWeights.append(inputWtDict)
                        }
                        newWeights[aNeuron]  = newInputWeights
                    }
                    
                    layersErrorOByNetO.append(aLayerErrorOByNetO)
                    currentLayerCount += 1
                }
                
                for aNeuron in newWeights.keys {
                    
                    let newNeuronInputWeights = newWeights[aNeuron]
                    for tp in newNeuronInputWeights! {
                        aNeuron.inputs[tp.0]!.weight = tp.1
                    }
                }
                
                //Completion block
                let cutOff:CGFloat = 0.005 //Reducing number of UI updates
                let percentComplete = CGFloat(ioSetIndex) / CGFloat(trainingSets.count)
                if (percentComplete - currentPercentCompletion > cutOff || percentComplete > 0.99) {
                    currentPercentCompletion += cutOff
                    
                    theSelf.networkVC?.updateNetworkView(layers: theSelf.layers, percentComplete:percentComplete)
                    
                    //DispatchQueue.main.async {
                    //    completionBlock!(false, percentComplete)
                    //}
                }
            }
            
            
            DispatchQueue.main.async {
                completionBlock!(true, 100.0)
            }
        }
        
    }
    
    
    //Use this for testing the FFNN after the training
    
    
    func getOutputFor(inputs:[[Double]]) -> [[Double]] {
        
        var outputs = [[Double]]()
        
        for (inputIndex,inputSet) in inputs.enumerated() {
            
            DebugLog("^^^ Test result \(inputIndex)-->")
            
            if (self.checkCompatibility(input:inputSet, output:nil) == false) { break }
            
            var output = [Double]()
            
            for (index,layer) in self.layers.enumerated() {
                
                if index == 0 {
                    for (neuronIndex,neuron) in layer.enumerated() {
                        neuron.output = inputSet[neuronIndex]
                        neuron.calculateOutput()
                    }
                }
                else {
                    for neuron in layer {
                        neuron.calculateOutput()
                        if (index == self.layers.count - 1) {
                            DebugLog("\(neuron.identifier) output : \(neuron.output)")
                            
                            output.append(neuron.output!)
                        }
                    }
                }
            }
            
            outputs.append(output)
            
            DebugLog("--------")
        }
        
        self.networkVC?.displayOutputView(inputs: inputs, outputs: outputs, layers:self.layers)
        
        return outputs
    }
    
    
}
