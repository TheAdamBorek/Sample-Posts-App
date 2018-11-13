//
//  PostDetailsViewModel.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 13/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol PostDetailsViewModelType {
    var postTitle: String { get }
    var postBody: String { get }
    var author: Driver<String> { get }
    var numberOfComments: Driver<String> { get }
}

final class PostDetailsViewModel: PostDetailsViewModelType {
    private let post: Post
    private let userUseCase = GetUserUseCase()
    private let commentsUseCase = GetCommentsUseCase()
    let author: Driver<String>
    let numberOfComments: Driver<String>

    init(post: Post) {
        self.post = post

        func serializeUserInfo(_ user: User) -> String {
            return "\(user.name), \(user.username), \(user.email)"
        }

        self.author = userUseCase.user(with: post.authorsId)
            .map(serializeUserInfo)
            .asDriver(onErrorJustReturn: "")

        self.numberOfComments = commentsUseCase.comments(for: post)
            .map { String(describing: $0.count) }
            .asDriver(onErrorJustReturn: "")
    }

    var postTitle: String {
        return post.title
    }

    var postBody: String {
        return post.body
    }
}
