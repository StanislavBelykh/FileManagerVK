//
//  AppDelegate.swift
//  FileManagerVK
//
//  Created by Станислав on 14.04.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let loginViewController = LoginViewController()
        let navigationViewController = UINavigationController(rootViewController: loginViewController)
        navigationViewController.navigationBar.isTranslucent = false
        navigationViewController.navigationBar.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        navigationViewController.navigationBar.barTintColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        navigationViewController.navigationBar.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) ]
        navigationViewController.navigationBar.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
        // Override point for customization after application launch.
        return true
    }

}

