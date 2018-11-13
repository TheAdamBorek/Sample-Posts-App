//
//  Comment+fake.swift
//  SimplePostsAppTests
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
@testable import SimplePostsApp

extension Comment {
    static func fake(id: Int = 1,
                     name: String = "name",
                     body: String = "body",
                     postId: Int = 1,
                     authorsEmail: String = "email") -> Comment {
        return Comment(id: id, name: name, body: body, postId: postId, authorsEmail: authorsEmail)
    }
}
