//
// Created by Adam Borek on 2018-11-10.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol PostsListViewModelType {
    var posts: Driver<[PostsListCellViewModelType]> { get }
    var errorMessage: Driver<String> { get }
    var didTapAtIndex: PublishRelay<Int> { get }
}

protocol PostsListCellViewModelType {
    var title: String { get }
    var body: String { get }
    var author: String { get }
}

final class PostsListViewModel: PostsListViewModelType {
    let posts: Driver<[PostsListCellViewModelType]>
    let errorMessage: Driver<String>
    var navigator: PostDetailsNavigating?
    let didTapAtIndex = PublishRelay<Int>()

    private let disposeBag = DisposeBag()
    init(postListUseCase: GetPostsListUseCase) {
        let postsResults = postListUseCase.posts().materialize()
            .share(replay: 1)
        
        self.posts = postsResults.elemnts()
            .mapMany(PostsListCellViewModel.init)
            .asDriver(onErrorJustReturn: [])

        self.errorMessage = postsResults.errors()
            .mapTo("An error ocured. Please try agains")
            .asDriver(onErrorDriveWith: .empty())

        self.didTapAtIndex
            .withLatestFrom(postsResults.elemnts()) { index, posts in return posts[index] }
            .subscribe(onNext: { [weak self] post in
                self?.navigator?.show(detailsOf: post)
            })
            .disposed(by: disposeBag)
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
