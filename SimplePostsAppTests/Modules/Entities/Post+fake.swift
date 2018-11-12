//
//  Post+fake.swift
//  SimplePostsAppTests
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
@testable import SimplePostsApp

extension Post {
    static func fake(id: Int = 1,
                     title: String = "the title",
                     body: String = "the body",
                     authorsId: Int = 1) -> Post {
        return Post(id: id, title: title, body: body, authorsId: authorsId)
    }
}
