//
//  ViewController.swift
//  Simple-Swift-AI
//
//  Created by Arjun Gupta on 9/30/16.
//  Copyright © 2016 Arjun Gupta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = AI_System_XOR(rootVC:self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

