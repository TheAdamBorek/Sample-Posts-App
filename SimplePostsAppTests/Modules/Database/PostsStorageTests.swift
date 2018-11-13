//
//  PostsStorageTests.swift
//  SimplePostsAppTests
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import RealmSwift
import XCTest
@testable import SimplePostsApp

final class PostsStorageTests: XCTestCase {
    var storage: PostsStorage!
    var userStorage: UsersStorage!
    let realmConfig = Realm.Configuration(inMemoryIdentifier: "userStorageTests")

    override func setUp() {
        super.setUp()
        storage = RealmPostsStorage(realmConfig: realmConfig)
        userStorage = RealmUsersStorage(realmConfig: realmConfig)
    }

    override func tearDown() {
        realmConfig.deleteAllObjects()
        super.tearDown()
    }

    func test_savingPost_whenAuthorIsNotInDatabaseYet_shouldRaiseError() {
        let post = Post.fake(id: 1, authorsId: 1)
        XCTAssertThrowsError(try storage.save(post))
    }

    func test_savingPost() throws {
        let author = User.fake(id: 1)
        let post = Post.fake(id: 1, authorsId: author.id)
        try userStorage.save(author)
        try storage.save(post)
        let postFromDB = try storage.post(with: post.id)
        XCTAssertEqual(post, postFromDB)
    }
}
