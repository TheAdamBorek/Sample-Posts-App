//
//  BackgroundSyncInitializer.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 13/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import UIKit

final class BackgroundSyncInitializer: Initializer {
    func initialize(with options: [UIApplication.LaunchOptionsKey : Any]?) {
        let apiClient = APIClient(hostURL: Configuration.shared.host)
        let storage = Storage(users: RealmUsersStorage(), posts: RealmPostsStorage(), comments: RealmCommentsStorage())
        let backgroundSync = BackgroundSyncUseCase(notifications: SystemNotifications(), apiClient: apiClient, storage: storage)
        backgroundSync.start()
    }
}
