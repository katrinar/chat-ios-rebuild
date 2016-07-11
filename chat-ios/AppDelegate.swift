//
//  AppDelegate.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/9/16.
//  Copyright © 2016 Velocity360. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FIRApp.configure()
        
        let frame = UIScreen.mainScreen().bounds
        self.window = UIWindow(frame: frame)
        
        let mapVc = CTMapViewController()
        let mapNavCtr = UINavigationController(rootViewController: mapVc)
        mapNavCtr.navigationBar.barTintColor = UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)
        mapNavCtr.navigationBar.tintColor = .whiteColor()
        
        let accountVc = CTAccountViewController()
        let accountNavCtr = UINavigationController(rootViewController: accountVc)
        accountNavCtr.navigationBar.barTintColor = UIColor(red: 0, green: 0.5, blue: 0.5, alpha: 1)
        accountNavCtr.navigationBar.tintColor = .whiteColor()
        
        let tabCtr = UITabBarController()
        tabCtr.viewControllers = [mapNavCtr, accountNavCtr]
        
        self.window?.rootViewController = tabCtr
        self.window?.makeKeyAndVisible()
        self.checkCurrentUser()
        
        return true
    }
    
    func checkCurrentUser(){
        
        APIManager.checkCurrentUser { response in
            if let currentUserInfo = response["currentUser"] as? Dictionary<String, AnyObject>{
                
                //                print("\(currentUserInfo)")
                
                let currentUser = CTProfile()
                currentUser.populate(currentUserInfo)
                
                let notification = NSNotification(
                    name: Constants.kUserLoggedInNotification,
                    object: nil,
                    userInfo: ["user":currentUserInfo]
                )
                
                let notificationCenter = NSNotificationCenter.defaultCenter()
                notificationCenter.postNotification(notification)
            }
        }
        
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
