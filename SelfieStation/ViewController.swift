//
//  ViewController.swift
//  SelfieStation
//
//  Created by Curtis Walker on 9/29/15.
//  Copyright (c) 2015 higherfidelity. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var TwitterButton: UIButton!
    
    @IBOutlet weak var EmailButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
         self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

