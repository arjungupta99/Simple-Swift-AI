//
//  NeuronInputsView.swift
//  Simple-Swift-AI
//
//  Created by Arjun Gupta on 9/22/16.
//  Copyright © 2016 ArjunGupta. All rights reserved.
//

import Foundation
import UIKit

class NeuronInputsView:UIView {
    
    var idLabel     :UILabel!
    var biasLabel   :UILabel!
    var inputLabels = [String:UILabel]()
    var circleView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let f = CGRect(x: 0, y: 0, width: 60, height: 60)
        
        self.circleView                     = UIView(frame: f)
        self.circleView.backgroundColor     = UIColor.lightGray
        self.circleView.backgroundColor     = UIColor(red: 1.0, green: 0.39, blue: 0.39, alpha: 1.0)
        self.circleView.layer.cornerRadius  = f.size.height/2
        self.circleView.center              = CGPoint(x: frame.size.width - f.size.width/2 - 10, y: frame.size.height/2)
        self.addSubview(self.circleView)
        
        self.idLabel                    = NeuronInputsView.makeLabel(f: f)
        self.idLabel.center             = CGPoint(x: f.size.width/2, y: f.size.height/2)
        self.circleView.addSubview(self.idLabel)
        self.idLabel.center             = CGPoint(x: f.size.width/2, y: f.size.height/2)
        
        self.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func buildInputs(inputs:[InputA]) {
        
        let vMargin:CGFloat         = 25
        let hMargin:CGFloat         = 5
        let hLabelMargin:CGFloat    = 10
        let lbHeight:CGFloat        = 16
        let lbWidth:CGFloat         = self.circleView.frame.origin.x - 2*hLabelMargin
        var labelBase:UIView?
        if inputs.count > 0 {
            labelBase = UIView(frame:CGRect(x: hMargin, y: vMargin, width: lbWidth + hMargin, height: self.bounds.size.height - 2*vMargin))
            labelBase?.backgroundColor   = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
            self.addSubview(labelBase!)
        }
        
        let topBase   = UIView(frame:CGRect(x: 0, y: 0, width: self.bounds.size.width, height: vMargin - 5))
        topBase.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        self.addSubview(topBase)
        
        let bottomBase   = UIView(frame:CGRect(x: 0, y: self.bounds.size.height - vMargin + 5, width: self.bounds.size.width, height: vMargin - 5))
        bottomBase.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        self.addSubview(bottomBase)
        
        if inputs.count > 0 {
            let wf                  = CGRect(x: 7, y: 0, width: 100, height: vMargin - 3)
            let weightLabel         = self.makeWeightsLabel(f: wf)
            weightLabel.textColor   = UIColor.gray
            weightLabel.font        = UIFont(name: "Helvetica", size: 13)
            weightLabel.text        = "WEIGHTS"
            topBase.addSubview(weightLabel)
        }
        
        let bf                          = CGRect(x: 0, y: 0, width: self.bounds.size.width - 10, height: vMargin - 3)
        self.biasLabel                  = self.makeWeightsLabel(f: bf)
        self.biasLabel.textColor        = UIColor(red: 1.0, green: 0.39, blue: 0.39, alpha: 1.0)
        self.biasLabel.font             = UIFont(name: "Helvetica", size: 13)
        self.biasLabel.textAlignment    = .right
        bottomBase.addSubview(self.biasLabel)
        
        //Input labels
        for (_,input) in inputs.enumerated() {
            let f                   = CGRect(x: 0, y: 0, width: lbWidth, height: lbHeight)
            let lb                  = self.makeWeightsLabel(f: f)
            lb.center               = CGPoint(x: 5 + lb.frame.size.width/2, y: 5 + lb.frame.size.height * CGFloat(input.indexInLayer) + lb.frame.size.height / 2)
            labelBase?.addSubview(lb)
            if let neuron = input.neuron {
                lb.text             = neuron.identifier +  " : " + String(input.weight)
                self.inputLabels[neuron.identifier] = lb
                
                if let theBias = neuron.bias {
                    biasLabel.text          = "BIAS \(theBias)"
                }
            }
        }
    }
    
    
    func makeWeightsLabel(f:CGRect) -> UILabel {
        let lb                          = NeuronInputsView.makeLabel(f: f)
        lb.frame                        = f
        lb.font                         = UIFont(name: "Helvetica", size: 13)
        lb.textColor                    = UIColor.black
        lb.textAlignment                = .left
        lb.adjustsFontSizeToFitWidth    = false
        lb.minimumScaleFactor           = 1.0
        return lb
    }
    
    
    class func makeLabel(f:CGRect) -> UILabel {
        let lbl                         = UILabel(frame:f)
        lbl.font                        = UIFont(name: "Helvetica", size: 20)
        lbl.minimumScaleFactor          = 0.5
        lbl.textColor                   = UIColor.white
        lbl.textAlignment               = .center
        lbl.adjustsFontSizeToFitWidth   = true
        return lbl
    }
}
