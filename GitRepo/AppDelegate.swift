//
//  AppDelegate.swift
//  GitRepo
//
//  Created by Стажер on 01.03.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               
        if UserDefaults.standard.object(forKey: "token") != nil {
            let repoVC = storyboard.instantiateViewController(withIdentifier: "ListNavigationVC")
            window.rootViewController = repoVC
        } else {
            let authVC = storyboard.instantiateViewController(withIdentifier: "AuthNavigationVC")
            window.rootViewController = authVC
        }
        window.makeKeyAndVisible()
        self.window = window

        return true
    }

}

