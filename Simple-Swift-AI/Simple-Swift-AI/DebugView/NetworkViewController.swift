//
//  NetworkViewController.swift
//  Simple-Swift-AI
//
//  Created by Arjun Gupta on 9/21/16.
//  Copyright © 2016 ArjunGupta. All rights reserved.
//

import Foundation
import UIKit

class NetworkViewController:UIViewController {
    
    
    @IBOutlet weak var networkContainer     : UIView!
    @IBOutlet weak var infoLabel            : UILabel!
    @IBOutlet weak var learningRateLabel    : UILabel!
    @IBOutlet weak var scrollView           : UIScrollView!
    @IBOutlet weak var progressBar          : UIProgressView!
    @IBOutlet weak var trainingProgressLabel: UILabel!
    @IBOutlet weak var testInputsButton     : UIButton!
    
    
    var neuronViews = [String:NeuronInputsView]()
    weak var parentView:UIView?
    private let outputTableController = OutputTableController()
    private var testInputs  :[[Double]]?
    private var testOutputs :[[Double]]?
    private var testLayers  :[[NeuronA]]?
    
    
    class func loadVC(rootVC:UIViewController) -> NetworkViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "id_networkVC") as! NetworkViewController
        
        let navController = UINavigationController(rootViewController: vc)
        
        rootVC.present(navController, animated: false, completion: nil)
        
        vc.automaticallyAdjustsScrollViewInsets = false
        
        return vc
    }
    
    
    //MARK:- View Setup
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Simple Swift AI - FFNN"
    }
    
    
    func buildView(layers:[[NeuronA]], learningRate:CGFloat) {
        
        self.progressBar?.isHidden           = false
        self.trainingProgressLabel?.isHidden = false
        self.testInputsButton?.isHidden      = true
        
        let cSize = self.view.bounds.size
        
        let topOffset   :CGFloat    = 55
        let vertGap     :CGFloat    = 15
        let horizGap    :CGFloat    = 25
        let wInput      :CGFloat    = 80
        var wOther      :CGFloat    = (cSize.width - (CGFloat(layers.count + 2) * horizGap) - wInput) / CGFloat(layers.count - 1)
        wOther                      = max(wOther, 265)
        
        var maxW    :CGFloat        = 0
        var maxH    :CGFloat        = 0
        
        var maxNumOfNeurons = 0
        for layer in layers {
            maxNumOfNeurons = max(maxNumOfNeurons, layer.count)
        }
        let h       :CGFloat    = max(123, 123 + 16 * CGFloat(maxNumOfNeurons - 4))
        
        for (layerIndex,layer) in layers.enumerated() {
            
            let w:CGFloat  = layerIndex == 0 ? wInput : wOther
            let xPos       = layerIndex == 0 ? horizGap : horizGap + CGFloat(layerIndex) * (horizGap + w) - (wOther - wInput)
            
            
            //Layer Label
            var layerLabelText = "Input"
            if (layerIndex == layers.count - 1) {
                layerLabelText = "Output"
            }
            else if (layerIndex == 0) {
                layerLabelText = "Input"
            }
            else {
                layerLabelText = "Hidden"
            }
            let llbFrame                = CGRect(x: xPos, y: 25, width: 75, height: 25)
            let layerLabel              = NeuronInputsView.makeLabel(f: llbFrame)
            layerLabel.text             = layerLabelText
            layerLabel.textAlignment    = .left
            layerLabel.textColor        = UIColor.lightGray
            self.scrollView.addSubview(layerLabel)
            
            
            //Neuron Views
            for (neuronIndex,neuron) in layer.enumerated() {
                
                let nf          = CGRect(x: xPos, y: topOffset + vertGap + CGFloat(neuronIndex) * (vertGap + h), width: w, height: h)
                let neuronView  = NeuronInputsView(frame: nf)
                neuronView.idLabel.text = String(describing: neuron.identifier )
                self.scrollView.addSubview(neuronView)
                
                var theInputs   = [InputA]()
                for key in neuron.inputs.keys {
                    let val = neuron.inputs[key]!
                    theInputs.append(val)
                }
                neuronView.buildInputs(inputs:theInputs)
                
                self.neuronViews[neuron.identifier] = neuronView
                
                if (neuronView.frame.maxX > maxW) {
                    maxW = neuronView.frame.maxX
                }
                if (neuronView.frame.maxY > maxH) {
                    maxH = neuronView.frame.maxY
                }
            }
        }
        
        let sz = CGSize(width: maxW + 20, height: maxH + 20)
        self.scrollView.contentSize = sz
        
        let numInputs   = layers[0].count
        let numOutputs  = layers[layers.count - 1].count
        let numHidden   = layers.count - 2
        
        let inputStr    = numInputs > 1     ? "Inputs"  : "Input"
        let outputStr   = numOutputs > 1    ? "Outputs" : "Output"
        let hiddenStr   = numHidden > 1     ? "layers"  : "layer"
        self.infoLabel.text = "\(numInputs) \(inputStr) and \(numOutputs) \(outputStr)  |   \(numHidden) Hidden \(hiddenStr)"
        self.learningRateLabel.text = String(describing: learningRate)
        
    }
    
    
    
    //MARK:- View Updating
    
    
    
    func updateNetworkView(layers:[[NeuronA]], percentComplete:CGFloat) {
        
        DispatchQueue.main.async { [weak self] in
            guard let theSelf = self else { return }
            
            for (_,layer) in layers.enumerated() {
                for (_,neuron) in layer.enumerated() {
                    let neuronView = theSelf.neuronViews[neuron.identifier]!
                    if neuron.inputs.count > 0 {
                        for inputKey in neuron.inputs.keys {
                            let inputLabel = neuronView.inputLabels[inputKey]
                            let input = neuron.inputs[inputKey]!
                            
                            inputLabel?.text =  inputKey +  " : " + String(input.weight)
                            if let theBias = neuron.bias {
                                neuronView.biasLabel.text = "BIAS " + String(theBias)
                            }
                        }
                    }
                    else {
                        //Input neuron
                    }
                }
            }
            
            //Progress bar
            let progress = Float(percentComplete)
            theSelf.progressBar.setProgress(progress, animated: true)
        }
    }
    
    
    
    //MARK:- Output View
    
    
    
    func displayOutputView(inputs:[[Double]], outputs:[[Double]], layers:[[NeuronA]]) {
        
        if inputs.count != outputs.count { return }
        
        self.testInputs     = inputs
        self.testOutputs    = outputs
        self.testLayers     = layers
        
        self.deployTestOutputView()
    }
    
    
    private func deployTestOutputView() {
        
        guard  let theTestInputs    = self.testInputs   else { return }
        guard  let theTestOutputs   = self.testOutputs  else { return }
        guard  let theTestLayers    = self.testLayers   else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "id_outputTable") as! OutputTableController
        vc.inputs   = theTestInputs
        vc.outputs  = theTestOutputs
        vc.layers   = theTestLayers
        
        let navController = UINavigationController(rootViewController: vc)
        
        self.present(navController, animated: true) { 
            
            self.progressBar.isHidden           = true
            self.trainingProgressLabel.isHidden = true
            self.testInputsButton.isHidden      = false
            
        }
        
    }
    
    @IBAction func testInputsButtonHandle(_ sender: AnyObject) {
        
        self.deployTestOutputView()
    }
    
    
}
