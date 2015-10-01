//
//  camerViewController.swift
//  SelfieStation
//
//  Created by Curtis Walker on 9/29/15.
//  Copyright (c) 2015 higherfidelity. All rights reserved.
//

import UIKit
import AVFoundation

class cameraViewController: UIViewController {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var capturedImage: UIImageView!
    
    var TwHandle:String?
    var appDelegate: AppDelegate!
    
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    @IBOutlet var labelForBinaryCount: UILabel!

    
    var Count = 10
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        println(appDelegate.userTwitterHandle!);
        start()
        // Do any additional setup after loading the view, typically from a nib.
        updateText()
            }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let videoDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        var captureDevice:AVCaptureDevice?
        
        for device in videoDevices{
            let device = device as! AVCaptureDevice
            if device.position == AVCaptureDevicePosition.Front {
                captureDevice = device
                
            }
        }
        
        
        
        var backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var error: NSError?
        var input = AVCaptureDeviceInput(device: captureDevice, error: &error)
        
        
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
                previewView.layer.addSublayer(previewLayer)
                
                captureSession!.startRunning()
            }
        }
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer!.frame = previewView.bounds
    }
    
    @IBAction func didPressTakePhoto() {
        
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    var dataProvider = CGDataProviderCreateWithCFData(imageData)
                    var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, kCGRenderingIntentDefault)
                    
                    var image = UIImage(CGImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.Right)
                    self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    self.appDelegate.capturedImage = image
                }
            })
        }
    }
    
    @IBAction func didPressTakeAnother(sender: AnyObject) {
        captureSession!.startRunning()
    }


    
    @IBAction func start() {
        
        //timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "countUp", userInfo: nil, repeats: true)
        
        timer = NSTimer(timeInterval: 1.0, target: self, selector: "countDown", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func countDown() {
        
        Count -= 1
        println(Count)
        updateText()
        
        if (Count == 10) { Count = 10 }
        else if (Count == 0) {
            didPressTakePhoto()
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue()) {
                
                let EndingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("theEnding") as! theEndingViewController
                self.presentViewController(EndingViewController, animated: true, completion: nil)
            }

            reset()
        
        
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

    
    
    
}