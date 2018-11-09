//
// Created by Adam Borek on 2018-11-09.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import UIKit

public final class MainNavigator {
    private let window: UIWindow

    public init(window: UIWindow) {
        self.window = window
    }

    func navigateToFirstScene() {
        let postListViewController = PostsListViewController()
        let navigationController = UINavigationController(rootViewController: postListViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
