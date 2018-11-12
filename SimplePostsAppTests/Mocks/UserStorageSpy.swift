//
// Created by Adam Borek on 2018-11-12.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
@testable import SimplePostsApp

final class UserStorageSpy: UserStorage {
    var failingReason: Error?

    var users = [User]()

    func save(_ user: User) throws {
        if let failingReason = failingReason {
            throw failingReason
        }
        users.append(user)
    }

    func save(_ users: [User]) throws {
        if let failingReason = failingReason {
            throw failingReason
        }
        self.users.append(contentsOf: users)
    }
}
