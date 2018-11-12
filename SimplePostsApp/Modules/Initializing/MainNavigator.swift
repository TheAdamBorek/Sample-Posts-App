//
// Created by Adam Borek on 2018-11-09.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import UIKit

 final class MainNavigator {
    private let window: UIWindow

     init(window: UIWindow) {
        self.window = window
    }

    func navigateToFirstScene() {
        let useCase = GetPostsListUseCase(postStorage: RealmPostsStorage())
        let viewModel = PostsListViewModel(postListUseCase: useCase)
        let postListViewController = PostsListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: postListViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
