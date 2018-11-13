//
//  AppDelegate.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 07/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import UIKit

protocol Initializer {
    func initialize(with options: [UIApplication.LaunchOptionsKey: Any]?)
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    private let window = UIWindow()
    private let initializers: [Initializer] = [BackgroundSyncInitializer()]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initializers.forEach { $0.initialize(with: launchOptions) }
        let mainNavigator = MainNavigator(window: window)
        mainNavigator.navigateToFirstScene()
        return true
    }
}

