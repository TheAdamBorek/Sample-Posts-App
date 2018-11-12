//
// Created by Adam Borek on 2018-11-12.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
@testable import SimplePostsApp
extension User {
    static func fake(id: Int = 1,
                    name: String = "the name",
                    username: String = "username",
                    email: String = "email") -> User {
        return User(id: id, name: name, username: username, email: email)
    }
}
