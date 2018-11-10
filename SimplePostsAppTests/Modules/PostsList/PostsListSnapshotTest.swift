//
// Created by Adam Borek on 2018-11-10.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//
@testable import SimplePostsApp

final class PostsListSnapshotTest: SnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = true
    }

    func test_postsList() {
        let viewController = PostsListViewController()
        verifyForScreens(view: viewController.view)
    }
}
