//
//  AppDelegate.swift
//  geoDash
//
//  Created by Aldin Fajic on 7/13/16.
//  Copyright © 2016 Aldin Fajic. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SessionMDelegate, ChartboostDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch {
            print("could not remove file")
        }
        
        // sessionM
        SessionM.sharedInstance().delegate = self
        SessionM.sharedInstance().startSessionWithAppID(Constants().sessionMKey)
        
        //chartboost
        Chartboost.startWithAppId(Constants().chartAppId, appSignature: Constants().chartAppSig, delegate: self)
        Chartboost.cacheRewardedVideo(CBLocationMainMenu)
        Chartboost.cacheInterstitial(CBLocationHomeScreen)
        return true
    }
    
    func didCompleteRewardedVideo(location: String!, withReward reward: Int32) {
        // give 10 swipes
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.integerForKey("swipes") != 0 {
            let swipes = userDefaults.integerForKey("swipes")
            let newSwipes = swipes + 10
            userDefaults.setInteger(newSwipes, forKey: "swipes")
        }else {
            userDefaults.setInteger(15, forKey: "swipes")
        }
        
        SessionM.sharedInstance().logAction("watch_video")
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(5, forKey: "swipes")
        
    }
    
    
}

