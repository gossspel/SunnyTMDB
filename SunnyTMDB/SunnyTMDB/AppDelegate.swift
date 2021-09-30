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
        let presenter: MovieSearchPresenterProtocol = MovieSearchPresenter()
        let vc = MovieSearchVC(presenter: presenter)
        vc.view.backgroundColor = UIColor.white
        let nc = UINavigationController(rootViewController: vc)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
        return true
    }
    
    // TODO: Finish the project using MVP architecture first
}

