//
//  AppDelegate.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/9/16.
//  Copyright © 2016 Velocity360. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let frame = UIScreen.mainScreen().bounds
        self.window = UIWindow(frame: frame)
        
        let mapVc = CTMapViewController()
        
        let accountVc = CTAccountViewController()
        let accountNavCtr = UINavigationController(rootViewController: accountVc)
        
        let tabCtr = UITabBarController()
        tabCtr.viewControllers = [mapVc, accountNavCtr]
        
        self.window?.rootViewController = tabCtr
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        
    }
    
    
}
