//
// Created by Adam Borek on 2018-11-10.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import RxCocoa
import RxSwift

@testable import SimplePostsApp

final class PostsListSnapshotTest: SnapshotTestCase {
    override func setUp() {
        super.setUp()
    }

    func test_postsList() {
        let viewController = PostsListViewController(viewModel: DummyPostsListViewModel())
        verifyForScreens(view: viewController.view)
    }
}

class DummyPostsListViewModel: PostsListViewModelType {
    var posts: Driver<[PostsListCellViewModelType]> {
        return .just([DummyPostListCellViewModel(), DummyPostListCellViewModel(), DummyPostListCellViewModel()])
    }

    let errorMessage = Driver<String>.empty()
    let didTapAtIndex = PublishRelay<Int>()
}

class DummyPostListCellViewModel: PostsListCellViewModelType {
    private(set) var title: String = "The longer title"
    private(set) var body: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt."
    private(set) var author: String = "Adam Borek"
}

