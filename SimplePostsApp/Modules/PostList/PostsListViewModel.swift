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
}

protocol PostsListCellViewModelType {
    var title: String { get }
    var body: String { get }
    var picture: Driver<UIImage> { get }
    var createdDate: String { get }
    var readTime: String { get }
    var authorName: String { get }
    var authorAvatar: Driver<UIImage> { get }
}

final class PostsListViewModel: PostsListViewModelType {
    let posts: Driver<[PostsListCellViewModelType]>

    init(postListUseCase: GetPostsListUseCase) {
        self.posts = postListUseCase.posts()
            .mapMany(PostsListCellViewModel.init)
            .asDriver(onErrorJustReturn: [])
    }

    private let _posts = [
        DummyPostListCell(),
        DummyPostListCell(),
        DummyPostListCell(),
        DummyPostListCell(),
        DummyPostListCell()
    ]
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

    private(set) var createdDate: String = "10 November 2018"
    private(set) var readTime: String = "5 min"
    private(set) var authorName: String = "Adam Borek"
    lazy var picture: Driver<UIImage> = {
        return Driver.just(UIImage(named: "image_placeholder") ?? UIImage())
    }()

    lazy var authorAvatar: Driver<UIImage> = {
        return Driver.just(UIImage(named: "author_placeholder") ?? UIImage())
    }()

}

class DummyPostListCell: PostsListCellViewModelType {
    private(set) var title: String = "The longer title"
    private(set) var body: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt."
    private(set) var createdDate: String = "10 November 2018"
    private(set) var readTime: String = "5 min"
    private(set) var authorName: String = "Adam Borek"
    lazy var picture: Driver<UIImage> = {
        return Driver.just(UIImage(named: "image_placeholder") ?? UIImage())
    }()

    lazy var authorAvatar: Driver<UIImage> = {
        return Driver.just(UIImage(named: "author_placeholder") ?? UIImage())
    }()
}
