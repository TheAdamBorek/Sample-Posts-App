//
//  PostsListCellSnapshotTest.swift
//  SimplePostsAppTests
//
//  Created by Adam Borek on 11/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import UIKit
@testable import SimplePostsApp

final class PostsListCellSnapshotTest: SnapshotTestCase {
    override func setUp() {
        super.setUp()
    }

    func test_postCell() {
        let cell = PostsListCell.fromXib(translatesAutoresizingMaskIntoConstraints: false)
        let iPhoneXWidth = ScreenSize.iPhoneX.bounds.width
        let bounds = CGRect(x: 0, y: 0, width: iPhoneXWidth, height: 350)
        cell.viewModel = DummyPostListCell()
        verify(view: cell, frame: bounds)
    }
}
