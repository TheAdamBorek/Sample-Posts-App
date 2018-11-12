//
// Created by Adam Borek on 2018-11-12.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
class Storage {
    private let users: UsersStorage
    private let posts: PostsStorage
    private let comments: CommentsStorage

    init(users: UsersStorage, posts: PostsStorage, comments: CommentsStorage) {
        self.users = users
        self.posts = posts
        self.comments = comments
    }
}

extension Storage: UsersStorage {
    func user(with id: Int) throws -> User {
        return try users.user(with: id)
    }

    func allUsers() throws -> [User] {
        return try users.allUsers()
    }

    func save(_ user: User) throws {
        try users.save(user)
    }

    func save(_ users: [User]) throws {
        try self.users.save(users)
    }

}

extension Storage: PostsStorage {
    func post(with id: Int) throws -> Post {
        return try post(with: id)
    }

    func allPosts() throws -> [Post] {
        return try posts.allPosts()
    }

    func save(_ post: Post) throws {
        try posts.save(post)
    }

    func save(_ posts: [Post]) throws {
        try self.posts.save(posts)
    }
}

extension Storage: CommentsStorage {
    func comment(with id: Int) throws -> Comment {
        return try comments.comment(with: id)
    }

    func allComments() throws -> [Comment] {
        return try comments.allComments()
    }

    func save(_ comment: Comment) throws {
        try comments.save(comment)
    }

    func save(_ comments: [Comment]) throws {
        try self.comments.save(comments)
    }
}
