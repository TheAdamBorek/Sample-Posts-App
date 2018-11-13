//
// Created by Adam Borek on 2018-11-09.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import UIKit

final class MainNavigator: PostDetailsNavigating {
    private let window: UIWindow
    private var postLists: UIViewController?

     init(window: UIWindow) {
        self.window = window
    }

    func navigateToFirstScene() {
        let useCase = GetPostsListUseCase(postStorage: RealmPostsStorage())
        let viewModel = PostsListViewModel(postListUseCase: useCase)
        viewModel.navigator = self
        let postListViewController = PostsListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: postListViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        postLists = postListViewController
    }

    func show(detailsOf post: Post) {
        PostDetailsNavigator().show(detailsOf: post, onTopOf: postLists)
    }
}
