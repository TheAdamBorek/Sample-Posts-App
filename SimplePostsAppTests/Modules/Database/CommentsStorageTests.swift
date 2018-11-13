//
//  CommentsStorageTests.swift
//  SimplePostsAppTests
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import RealmSwift
import XCTest
@testable import SimplePostsApp

final class CommentsStorageTests: XCTestCase {
    var storage: CommentsStorage!
    var userStorage: UsersStorage!
    var postStorage: PostsStorage!
    let realmConfig = Realm.Configuration(inMemoryIdentifier: "commentsStorageTests")

    override func setUp() {
        super.setUp()
        storage = RealmCommentsStorage(realmConfig: realmConfig)
        userStorage = RealmUsersStorage(realmConfig: realmConfig)
        postStorage = RealmPostsStorage(realmConfig: realmConfig)
    }

    override func tearDown() {
        realmConfig.deleteAllObjects()
        super.tearDown()
    }

    func test_savingPost_whenAuthorIsNotInDatabaseYet_shouldRaiseError() {
        let comment = Comment.fake(id: 1, postId: 1)
        XCTAssertThrowsError(try storage.save(comment))
    }

    func test_savingPost() throws {
        try prefilDatabase()
        let comment = Comment.fake(postId: 1)
        try storage.save(comment)
        let commentFromDB = try storage.comment(with: comment.id)
        XCTAssertEqual(comment, commentFromDB)
    }

    private func prefilDatabase() throws {
        let author = User.fake(id: 1)
        let post = Post.fake(id: 1, authorsId: author.id)
        try userStorage.save(author)
        try postStorage.save(post)
    }
}

