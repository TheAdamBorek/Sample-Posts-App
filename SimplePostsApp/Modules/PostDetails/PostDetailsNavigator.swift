//
//  PostDetailsNavigator.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 13/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import UIKit

protocol PostDetailsNavigating {
    func show(detailsOf post: Post)
}

final class PostDetailsNavigator {
    private weak var postDetails: UIViewController?

    func show(detailsOf post: Post, onTopOf parent: UIViewController?) {
        let viewModel = PostDetailsViewModel(post: post)
        let viewController = PostDetailsViewController(viewModel: viewModel)
        postDetails = viewController
        parent?.show(viewController, sender: nil)
    }
}
