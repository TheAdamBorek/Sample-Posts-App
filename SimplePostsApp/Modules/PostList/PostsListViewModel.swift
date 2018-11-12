//
// Created by Adam Borek on 2018-11-10.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation

// In ideal world ViewModels shouldn't import UIKit, because ViewModels don't have references to UIViews.
// However, Apple designed UIKit to also contains UI models like UIImage or NSDataAsset.
// The decision whether ViewModel can use UIImages or other UI models depends on the project.
// For this POC I decided that creating a new type to hide UIImage from ViewModel would be an overkill.

import UIKit
import RxCocoa

protocol PostsListViewModelType {
    var posts: Driver<[PostsListCellViewModelType]> { get }
    var errorMessage: Driver<String> { get }
}

protocol PostsListCellViewModelType {
    var title: String { get }
    var body: String { get }
    var author: String { get }
}

final class PostsListViewModel: PostsListViewModelType {
    let posts: Driver<[PostsListCellViewModelType]>
    let errorMessage: Driver<String>

    init(postListUseCase: GetPostsListUseCase) {
        let postsResults = postListUseCase.posts().materialize()
            .share(replay: 1)
        
        self.posts = postsResults.elemnts()
            .mapMany(PostsListCellViewModel.init)
            .asDriver(onErrorJustReturn: [])

        self.errorMessage = postsResults.errors()
            .mapTo("An error ocured. Please try agains")
            .asDriver(onErrorDriveWith: .empty())
    }
}

class PostsListCellViewModel: PostsListCellViewModelType {
    private let post: Post
    init(post: Post) {
        self.post = post
    }

    var title: String {
        return post.title
    }

    var body: String {
        return post.body
    }

    var author: String {
        return String(describing: post.authorsId)
    }

}
