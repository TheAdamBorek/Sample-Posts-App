//
//  CommentsStorage.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//
import RealmSwift
import Foundation
protocol CommentsStorage {
    func comment(with id: Int) throws -> Comment
    func allComments() throws -> [Comment]
    func save(_ comment: Comment) throws
    func save(_ comments: [Comment]) throws
}

final class RealmCommentsStorage: CommentsStorage {
    private let realmConfig: Realm.Configuration
    private let genericRealm: GenericRealm
    init(realmConfig: Realm.Configuration = .defaultConfiguration) {
        self.realmConfig = realmConfig
        self.genericRealm = GenericRealm(configuration: realmConfig)
    }

    func comment(with id: Int) throws -> Comment {
        return try genericRealm.object(forPrimaryKey: id)
    }

    func allComments() throws -> [Comment] {
        return try genericRealm.findAll()
    }

    func save(_ comment: Comment) throws {
        let realm = try self.realm()
        guard let post = realm.object(ofType: PostObject.self, forPrimaryKey: comment.postId) else {
            throw RelationshipError(message: "Post with id: \(comment.postId) doesn't exists. Cannot link with the comment \(comment)")
        }
        let commentObject = comment.asRealmObject()
        commentObject.post = post
        try realm.write {
            realm.add(commentObject, update: true)
        }
    }

    func save(_ comments: [Comment]) throws {
        try comments.forEach { try save($0) }
    }

    private func realm() throws -> Realm {
        return try Realm(configuration: realmConfig)
    }
}

final class CommentObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var body: String = ""
    @objc dynamic var post: PostObject?
    @objc dynamic var authorsEmail: String = ""
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension CommentObject: DomainConvertible {
    func asDomain() -> Comment? {
        guard let post = post else { return nil }
        return Comment(id: id, name: name, body: body, postId: post.id, authorsEmail: authorsEmail)
    }
}

extension Comment: RealmConvertible {
    func asRealmObject() -> CommentObject {
        let object = CommentObject()
        object.id = id
        object.name = name
        object.body = body
        object.authorsEmail = authorsEmail
        return object
    }
}
