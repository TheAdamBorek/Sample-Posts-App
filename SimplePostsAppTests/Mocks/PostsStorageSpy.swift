//
//  PostStorageSpy.swift
//  SimplePostsAppTests
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
@testable import SimplePostsApp

final class PostsStorageSpy: PostsStorage {
    var failingReason: Error?
    var posts = [Post]()

    func save(_ post: Post) throws {
        try throwErrorIfGiven()
        posts.append(post)
    }

    func save(_ posts: [Post]) throws {
        try posts.forEach { try save($0) }
    }

    private func throwErrorIfGiven() throws {
        if let failingReason = failingReason {
            throw failingReason
        }
    }
}
