//
//  AppDelegate.swift
//  soriBase
//
//  Created by soriBao on 09/07/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = LoginVCtrl(viewModel: BaseViewModel())
        window?.makeKeyAndVisible()
        return true
    }


}

