//
// Created by Adam Borek on 2018-11-12.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
@testable import SimplePostsApp

final class UserStorageSpy: UsersStorage {
    var failingReason: Error?

    var users = [User]()

    func user(with id: Int) throws -> User {
        let user = users.first { $0.id == id }
        return user!
    }

    func save(_ user: User) throws {
        try throwErrorIfGiven()
        users.append(user)
    }

    func save(_ users: [User]) throws {
        try throwErrorIfGiven()
        self.users.append(contentsOf: users)
    }

    private func throwErrorIfGiven() throws {
        if let failingReason = failingReason {
            throw failingReason
        }
    }
}
