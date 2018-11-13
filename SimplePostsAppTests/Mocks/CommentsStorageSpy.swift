//
//  CommentsStorageSpy.swift
//  SimplePostsAppTests
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
@testable import SimplePostsApp

final class CommentsStorageSpy: CommentsStorage {
    var failingReason: Error?
    var comments = [Comment]()

    func comment(with id: Int) throws -> Comment {
        let comment = comments.first { $0.id == id }
        return comment!
    }

    func comments(for post: Post) throws -> [Comment] {
        fatalError("not implemented")
    }

    func allComments() throws -> [Comment] {
        return comments
    }

    func save(_ comment: Comment) throws {
        try throwErrorIfGiven()
        comments.append(comment)
    }

    func save(_ comments: [Comment]) throws {
        try comments.forEach { try save($0) }
    }

    private func throwErrorIfGiven() throws {
        if let failingReason = failingReason {
            throw failingReason
        }
    }
}
