//
//  AppDelegate.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/7/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        let VC = UIViewController()
        VC.view.backgroundColor = UIColor.white
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = VC
        window?.makeKeyAndVisible()
        return true
    }
}

