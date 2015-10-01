//
//  theEndingViewController.swift
//  SelfieStation
//
//  Created by Curtis Walker on 9/29/15.
//  Copyright (c) 2015 higherfidelity. All rights reserved.
//

import UIKit
import Social
import Accounts


class theEndingViewController: UIViewController {
    
    var TwHandle:String?
    var appDelegate: AppDelegate!
    
    
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet var labelForBinaryCount: UILabel!
    var Count = 10
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        println(appDelegate.userTwitterHandle!);
        println("Loaded ending page")
        self.capturedImage.image = self.appDelegate.capturedImage
        // Do any additional setup after loading the view, typically from a nib.
        start()
        updateText()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func start() {
        
        println("start function on ending page")
        //timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "countUp", userInfo: nil, repeats: true)
        tweetNow()
        timer = NSTimer(timeInterval: 1.0, target: self, selector: "countDown", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func countDown() {
        
        Count -= 1
        println(Count)
        updateText()
        
        if (Count == 10) { Count = 10 }
        else if (Count == 0) {reset()
            let LandingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LandingPage") as! ViewController
            
            
            presentViewController(LandingViewController, animated: true, completion: nil)
            
            updateText()
            
        }
        
    }
    
    @IBAction func reset() {
        
        timer.invalidate()
        
        Count = 10
        updateText()
    }
    
    func updateText() {
        
        var text = String(Count)
        for i in 0..<4 - count(text) {
            
            text = "0" + text;
        }
        
        labelForBinaryCount.text = text
    }
    
    func tweetNow()
    {
        
        var url = NSBundle.mainBundle().URLForResource("Fish", withExtension: "gif")
        var picUrl = NSBundle.mainBundle().URLForResource("ProblemSolving", withExtension: "png")
        let fileData = NSData(contentsOfFile: picUrl!.path!)
        let image = UIImage(data: fileData!)
        var image2 = self.appDelegate.capturedImage
        var imageData = UIImageJPEGRepresentation(image2, 0)
        

        
        let account = ACAccountStore()
        let accountType = account.accountTypeWithAccountTypeIdentifier(
            ACAccountTypeIdentifierTwitter)
        
        account.requestAccessToAccountsWithType(accountType, options: nil,
            completion: {(success: Bool, error: NSError!) -> Void in
                if success {
                    let arrayOfAccounts =
                    account.accountsWithAccountType(accountType)
                    
                    if arrayOfAccounts.count > 0 {
                        let twitterAccount = arrayOfAccounts.first as! ACAccount
                        var message = Dictionary<String, AnyObject>()
                        message["status"] = self.appDelegate.userTwitterHandle!  + "\r\n" + "A little lower" + "\r\n" + "#Cool"
                        println(imageData)
                        let requestURL = NSURL(string:
                            "https://api.twitter.com/1.1/statuses/update_with_media.json")
                        let postRequest = SLRequest(forServiceType:
                            SLServiceTypeTwitter,
                            requestMethod: SLRequestMethod.POST,
                            URL: requestURL,
                            parameters: message)
                        
                        
                        postRequest.account = twitterAccount
                        postRequest.addMultipartData(imageData, withName: "media", type: nil, filename: nil)
                        
                        
                        postRequest.performRequestWithHandler({
                            (responseData: NSData!,
                            urlResponse: NSHTTPURLResponse!,
                            error: NSError!) -> Void in
                            if let err = error {
                                println("Error : \(err.localizedDescription)")
                            }
                            println("Twitter HTTP response \(urlResponse.statusCode)")
                            
                        })
                    }
                }
                else
                {
                    var alert = UIAlertController(title: "Twitter Account", message: "Please login to your Twitter account.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
        })
    }
    

    
    
    
    
}
