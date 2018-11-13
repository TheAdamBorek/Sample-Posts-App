//
// Created by Adam Borek on 2018-11-12.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import RealmSwift
import XCTest
@testable import SimplePostsApp

final class UserStorageTests: XCTestCase {
    var storage: UsersStorage!
    let realmConfig = Realm.Configuration(inMemoryIdentifier: "userStorageTests")
    override func setUp() {
        super.setUp()
        storage = RealmUsersStorage(realmConfig: realmConfig)
    }

    override func tearDown() {
        realmConfig.deleteAllObjects()
        super.tearDown()
    }

    func testSavingUser() throws {
        let user = User.fake()
        try storage.save(user)
        let userFromDb = try storage.user(with: user.id)
        XCTAssertEqual(user, userFromDb)
    }

    func testSavingUsers() throws {
        let users = [User.fake(id: 1), User.fake(id: 2)]
        try storage.save(users)
        let usersFromDb = try storage.allUsers()
        XCTAssertEqual(users, usersFromDb)
    }
}

extension Realm.Configuration {
    func deleteAllObjects() {
        let realm = try? Realm(configuration: self)
        try? realm?.write {
            realm?.deleteAll()
        }
    }
}
