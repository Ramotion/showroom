//
//  AppDelegate.swift
//  RAMControls
//
//  Created by Alex K. on 12/10/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import ElongationPreview
import OAuthSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    configureNavigationBar()
    AppAnalytics.configuration([.google])
    configureElongationPreviewControl()
    ReelSearchViewModel.shared.initializeDatabase()
    
    return true
  }
}

// MARK: Handle callback url
extension AppDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (url.host == "oauth") {
            OAuthSwift.handle(url: url)
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let topVC = UIApplication.getTopMostViewController()
        guard topVC is DribbbleShotsViewController else { return }
        let dribbbleVC = topVC as! DribbbleShotsViewController
        if dribbbleVC.user == nil {
            dribbbleVC.dismiss(animated: true, completion: {
                let message = "You must be logged in\nto send a shot."
                UIAlertController.show(message: message, completionAction: { })
            })
        }
    }
}

extension AppDelegate {
  
    fileprivate func configureNavigationBar() {
        //transparent background
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        
        
        if let font = UIFont(name: "Avenir-medium", size: 18) {
            UINavigationBar.appearance().titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: font,
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
    config.detailPresentingDuration = 0.4
    config.detailDismissingDuration = 0.4
    
    // Customize behaviour
    config.headerTouchAction = .collpaseOnBoth
    
    // Save created appearance object as default
    ElongationConfig.shared = config
  }
  
}
