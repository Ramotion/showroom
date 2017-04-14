//
//  AppDelegate.swift
//  RAMControls
//
//  Created by Alex K. on 12/10/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import Firebase
import ElongationPreview

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    configureNavigationBar()
    Analytics.configuration([.google])
    configureElongationPreviewControl()
    
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
}

extension AppDelegate {
  
  fileprivate func configureNavigationBar() {
    //transparent background
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().isTranslucent = true
    
    
    if let font = UIFont(name: "Avenir-medium" , size: 18) {
      UINavigationBar.appearance().titleTextAttributes = [
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : font
      ]
    }
  }
  
  fileprivate func configureElongationPreviewControl() {
    // Customize ElongationConfig
    var config = ElongationConfig()
    config.scaleViewScaleFactor = 0.9
    config.topViewHeight = 190
    config.bottomViewHeight = 170
    config.bottomViewOffset = 20
    config.parallaxFactor = 100
    config.separatorHeight = 0.5
    config.separatorColor = UIColor.white
    
    // Durations for presenting/dismissing detail screen
    config.detailPresetingDuration = 0.4
    config.detailDismissingDuration = 0.4
    
    // Customize behaviour
    config.headerTouchAction = .collpaseOnBoth
    
    // Save created appearance object as default
    ElongationConfig.shared = config
  }
  
}
