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
        let apiClient = APIClient(hostURL: URL(string: "http://jsonplaceholder.typicode.com")!)
        let storage = Storage(users: RealmUsersStorage(), posts: RealmPostsStorage(), comments: RealmCommentsStorage())
        let backgroundSync = BackgroundSyncUseCase(notifications: SystemNotifications(), apiClient: apiClient, storage: storage)
        backgroundSync.start()
        mainNavigator.navigateToFirstScene()
        return true
    }
}

