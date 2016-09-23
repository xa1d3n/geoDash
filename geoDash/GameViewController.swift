//
//  GameViewController.swift
//  geoDash
//
//  Created by Aldin Fajic on 7/13/16.
//  Copyright (c) 2016 Aldin Fajic. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class GameViewController: UIViewController {
    
    var banner : GADBannerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if userDefaults.boolForKey("noAds") != true {
            banner = GADBannerView(adSize: kGADAdSizeSmartBannerLandscape)
            banner.adUnitID = Constants().adUnitId
            banner.rootViewController = self
            let req : GADRequest = GADRequest()
            req.testDevices = [kGADSimulatorID]
            banner.loadRequest(req)
            banner.frame = CGRectMake(0, view.frame.size.height - banner.frame.size.height, UIScreen.mainScreen().bounds.width, banner.frame.size.height)
            banner.tag = 100
            self.view.addSubview(banner)
        }
        
        if let scene = OptionsScene(fileNamed:"OptionsScene") {
            // Configure the view.
            let skView = self.view as! SKView
           // skView.showsFPS = true
           // skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
