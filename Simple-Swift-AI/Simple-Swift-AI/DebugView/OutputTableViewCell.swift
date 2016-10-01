//
//  OutputTableViewCell.swift
//  Simple-Swift-AI
//
//  Created by Arjun Gupta on 9/27/16.
//  Copyright © 2016 ArjunGupta. All rights reserved.
//

import Foundation
import UIKit

class OutputTableViewCell:UITableViewCell {
    
    @IBOutlet weak var cellIndexLabel   : UILabel!
    @IBOutlet weak var inputLabelView   : UIView!
    @IBOutlet weak var outputLabelView  : UIView!
    
    
    var inputLabels         = [UILabel]()
    var outputLabels        = [UILabel]()
    var inputNeuronLabels   = [UILabel]()
    var outputNeuronLabels  = [UILabel]()
}
