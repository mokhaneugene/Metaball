//
//  AppDelegate.swift
//  Metaball
//
//  Created by Eugene Mokhan on 15/08/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.makeKeyAndVisible()

        let viewController = ViewController() // Meta
//        let viewController = SecondViewController() // Animation

        window?.rootViewController = viewController

        return true
    }
}
