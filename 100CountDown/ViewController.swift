//
//  ViewController.swift
//  100CountDown
//
//  Created by mhtran on 4/8/15.
//  Copyright (c) 2015 mhtran. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController {
    
    var somay: UILabel!
    
    var t:Int?
    
    
    var chucmung = AVAudioPlayer()
    var chucmung2 = AVAudioPlayer()
    var nhacnen : AVAudioPlayer!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        t = NSUserDefaults.standardUserDefaults().integerForKey("somaymac")
        if (t == 0 ){
            t = 1
        }
        
        chucmung = self.caidatnhacchucmung("Congratulations_Sounds_Crazy_Cheer", type: "mp3")
        chucmung2 = self.caidatnhacchucmung("Congratulations_Sounds_HUMAN_ELEMENT_MALE_CONGRADULATIONS_01",type:"mp3")
        caidatnhacnen("11 Because of You.mp3")
        somay = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        somay.textAlignment = NSTextAlignment.Center
        
        somay.font = UIFont(name: "Chalkboard", size: 200)
        
        hienthisomaycon()
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "giam1may:")
        longPressRecognizer.minimumPressDuration = 2.0
        self.view.addGestureRecognizer(longPressRecognizer)
        
        somay.setTranslatesAutoresizingMaskIntoConstraints(false)
        let views = ["view":self.view, "somay":somay]
        self.view.addConstraint(NSLayoutConstraint(item: somay, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: somay, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
    }

    func giam1may(sender: UILongPressGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Ended){
            
        }
        if (sender.state == UIGestureRecognizerState.Began) {
                t? -= 1
            NSUserDefaults.standardUserDefaults().setInteger(t!, forKey: "somaymac")
            NSUserDefaults.standardUserDefaults().synchronize()
                NSLog("giam 1 may")
                hienthisomaycon()

        }
        
        
    }

    func hienthisomaycon(){
        somay.textColor = randomcolor()
        if (t != 0)
        {somay.text = NSString(UTF8String: "\(t!)")
            somay.font = UIFont(name: "Chalkboard", size: 200)
            self.view.addSubview(somay)
            chucmung.play()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            toggleTorch()
            toggleTorchOff()
            NSThread.sleepForTimeInterval(0.3)
            toggleTorch()
            toggleTorchOff()
        }
        else
        {
            somay.text = NSString(UTF8String: "Feather in your hand… Congratulations!")
            somay.font = UIFont(name: "Chalkboard", size: 16)
            self.view.addSubview(somay)
            chucmung2.play()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            toggleTorch()
            toggleTorchOff()
            NSThread.sleepForTimeInterval(0.3)
            toggleTorch()
            toggleTorchOff()
            t = 101
        }
        
        
        
    }
    
    func caidatnhacnen(file:NSString) {
        var path = NSBundle.mainBundle().URLForResource(file, withExtension: nil)
        if (path == nil) {
            return
        }
        
        var error:NSError? = nil
        nhacnen = AVAudioPlayer(contentsOfURL: path, error: &error)
        if (nhacnen == nil) {
            return
        }

        nhacnen = AVAudioPlayer(contentsOfURL: path, error: &error)
        nhacnen?.numberOfLoops = -1
        nhacnen?.prepareToPlay()
        nhacnen?.play()
    }
    
    func caidatnhacchucmung(file: NSString, type:NSString) -> AVAudioPlayer {
        var path = NSBundle.mainBundle().pathForResource(file, ofType: type)
        var url = NSURL.fileURLWithPath(path!)
        var error: NSError?
        var audioPlayer: AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        return audioPlayer!
    }

    func randomcolor()-> UIColor {
        var randomRed:CGFloat = CGFloat(drand48())
        var randomGreen:CGFloat = CGFloat(drand48())
        var randimBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randimBlue, alpha: 1.0)
    }
    
    func toggleTorch() {
        let avDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        // check if the device has torch
        if  avDevice.hasTorch {
            // lock your device for configuration
            avDevice.lockForConfiguration(nil)
            // check if your torchMode is on or off. If on turns it off otherwise turns it on
            avDevice.torchMode = avDevice.torchActive ? AVCaptureTorchMode.Off : AVCaptureTorchMode.On
            
            // sets the torch intensity to 100%
            avDevice.setTorchModeOnWithLevel(1.0, error: nil)
            // unlock your device
            avDevice.unlockForConfiguration()
            
        }
    }
    
    func toggleTorchOff() {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            device.lockForConfiguration(nil)
            let torchOn = !device.torchActive
            device.setTorchModeOnWithLevel(1.0, error: nil)
            device.torchMode = torchOn ? AVCaptureTorchMode.On : AVCaptureTorchMode.Off
            device.unlockForConfiguration()
        }
    }


}

