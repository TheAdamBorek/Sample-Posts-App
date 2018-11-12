//
//  AppDelegate.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 07/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    private let window = UIWindow()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let mainNavigator = MainNavigator(window: window)
        mainNavigator.navigateToFirstScene()
        return true
    }
}

