//
//  OutputTableController.swift
//  Simple-Swift-AI
//
//  Created by Arjun Gupta on 9/27/16.
//  Copyright © 2016 ArjunGupta. All rights reserved.
//

import Foundation
import UIKit

class OutputTableController:UITableViewController {
    
    var inputs                      :[[Double]]!
    var outputs                     :[[Double]]!
    var layers                      :[[NeuronA]]!
    private let neuronWidth         :CGFloat        = 35
    private let labelHeight         :CGFloat        = 50
    private let labelMargin         :CGFloat        = 10
    private let labelTopMargin      :CGFloat        = 30
    private let labelBottomMargin   :CGFloat        = 20
    private let labelSideMargin     :CGFloat        = 55
    private var cellHeight          :CGFloat        = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bbi = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.closeButtonHandle))
        self.navigationItem.rightBarButtonItem = bbi
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        self.navigationItem.title = "Test results"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let maxNeurons = max(self.inputs[0].count, self.outputs[0].count)
        self.cellHeight = self.labelTopMargin + self.labelHeight * CGFloat(maxNeurons) + self.labelMargin * CGFloat(maxNeurons - 1) + self.labelBottomMargin
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return inputs.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OutputTableViewCell
        
        
        cell.contentView.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.white : UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        cell.cellIndexLabel.text = String(indexPath.row)
        
        if (cell.inputLabels.count == 0) {
            
            let f = cell.frame
            let labelWidth = f.size.width/2 - 2 * self.neuronWidth
            cell.contentView.frame = CGRect(x: 0, y: 0, width: f.size.width, height: f.size.height)
            
            //Init input labels
            for i in stride(from:0, to:self.inputs[0].count, by:1) {
                
                //Input label
                let fi = CGRect(x: self.labelSideMargin, y: self.labelTopMargin + CGFloat(i) * self.labelHeight, width: labelWidth, height: self.labelHeight)
                let ilbl = self.makeLabel(f: fi)
                ilbl.textAlignment = .left
                cell.inputLabelView.addSubview(ilbl)
                cell.inputLabels.append(ilbl)
                
                //Input neuron label
                var fni = fi
                fni.origin.x    -= (self.neuronWidth + 10)
                fni.size.width  = self.neuronWidth
                fni.size.height = self.neuronWidth
                fni.origin.y    = fi.midY - self.neuronWidth/2
                let inlbl = self.makesSmallLabel(f: fni)
                cell.inputLabelView.addSubview(inlbl)
                cell.inputNeuronLabels.append(inlbl)
                
            }
            
            //Init output labels
            for i in stride(from:0, to:self.outputs[0].count, by:1) {
                
                let fo = CGRect(x: self.labelSideMargin, y: self.labelTopMargin + CGFloat(i) * self.labelHeight, width: labelWidth, height: self.labelHeight)
                let olbl = self.makeLabel(f: fo)
                olbl.textAlignment = .left
                cell.outputLabelView.addSubview(olbl)
                cell.outputLabels.append(olbl)
                
                //Output neuron label
                var fno = fo
                fno.origin.x    -= (self.neuronWidth + 10)
                fno.size.width  = self.neuronWidth
                fno.size.height = self.neuronWidth
                fno.origin.y    = fo.midY - self.neuronWidth/2
                let onlbl = self.makesSmallLabel(f: fno)
                onlbl.backgroundColor = UIColor(red: 1.0, green: 0.39, blue: 0.39, alpha: 1.0)
                cell.outputLabelView.addSubview(onlbl)
                cell.outputNeuronLabels.append(onlbl)
            }
        }
        
        for i in stride(from:0, to:self.inputs[0].count, by:1) {
            
            //Input label
            let ilbl = cell.inputLabels[i]
            let inputVal = String(describing: self.inputs[indexPath.row][i])
            ilbl.text = inputVal
            
            //Input neuron label
            let inlbl = cell.inputNeuronLabels[i]
            let inputNeuronVal = String(describing: self.layers[0][i].identifier)
            inlbl.text = inputNeuronVal
        }
        
        for i in stride(from:0, to:self.outputs[0].count, by:1) {
            
            //Output label
            let olbl = cell.outputLabels[i]
            
            let outputValue = self.outputs[indexPath.row][i]
            let outputVal   = String(format:"%f", outputValue)
            olbl.text = outputVal
            
            //Output neuron label
            let onlbl = cell.outputNeuronLabels[i]
            let outputNeuronVal = String(describing: self.layers[self.layers.count-1][i].identifier)
            onlbl.text = outputNeuronVal
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.cellHeight
    }
    
    
    func closeButtonHandle() {
        
        self.dismiss(animated: true) { 
            
        }
    }
    
    private func makeLabel(f:CGRect) -> UILabel {
        let lb              = NeuronInputsView.makeLabel(f: f)
        lb.font             = UIFont(name: "Helvetica", size: 41)
        lb.textColor        = UIColor(red: 0.07, green: 0.47, blue: 0.81, alpha: 1.0)
        lb.textAlignment    = .left
        //lb.backgroundColor  = UIColor.orange
        return lb
    }
    
    private func makesSmallLabel(f:CGRect) -> UILabel {
        let lb              = NeuronInputsView.makeLabel(f: f)
        lb.font             = UIFont(name: "Helvetica", size: 17)
        lb.textColor        = UIColor.white
        lb.textAlignment    = .center
        lb.backgroundColor  = UIColor(red: 1.0, green: 0.83, blue: 0.39, alpha: 1.0)
        lb.layer.cornerRadius = f.size.width/2
        lb.clipsToBounds    = true
        return lb
    }
}
