//
// Created by Adam Borek on 2018-11-12.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
struct User: Decodable {
    let id: Int
    let name: String
    let username: String
    let email: String
}

extension User: Equatable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.username == rhs.username &&
               lhs.email == rhs.email
    }
}
