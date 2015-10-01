//
//  twitterViewController.swift
//  SelfieStation
//
//  Created by Curtis Walker on 9/29/15.
//  Copyright (c) 2015 higherfidelity. All rights reserved.
//
import UIKit

class twitterViewController: UIViewController {
    
    var appDelegate: AppDelegate!
    
    
    
    @IBOutlet weak var SubmitButton: UIButton!

    @IBOutlet weak var UserTwitter: UITextField!
    
    var twitterHandle = ""
    
    
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ButtonPress(sender: AnyObject) {
        twitterHandle = UserTwitter.text!
        println(twitterHandle);
        appDelegate.userTwitterHandle = twitterHandle;
        
        
    }
    

    
    
}


