//
//  PostsStorage.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import RealmSwift

struct RelationshipError: Error {
    let message: String
}

protocol PostsStorage {
    func post(with id: Int) throws -> Post
    func allPosts() throws -> [Post]
    func save(_ post: Post) throws
    func save(_ posts: [Post]) throws
}

final class RealmPostsStorage: PostsStorage {
    private let realmConfig: Realm.Configuration
    private let genericRealm: GenericRealm
    init(realmConfig: Realm.Configuration) {
        self.realmConfig = realmConfig
        self.genericRealm = GenericRealm(configuration: realmConfig)
    }

    func post(with id: Int) throws -> Post {
        return try genericRealm.object(forPrimaryKey: id)
    }

    func allPosts() throws -> [Post] {
        return try genericRealm.findAll()
    }

    func save(_ post: Post) throws {
        let realm = try self.realm()
        guard let author = realm.object(ofType: UserObject.self, forPrimaryKey: post.authorsId) else {
            throw RelationshipError(message: "Author with id: \(post.authorsId) doesn't exists. Cannot link with the post \(post)")
        }
        let postObject = post.asRealmObject()
        postObject.author = author
        try realm.write {
            realm.add(postObject, update: true)
        }
    }

    func save(_ posts: [Post]) throws {
        posts.forEach {
            try? save($0)
        }
    }

    private func realm() throws -> Realm {
        return try Realm(configuration: realmConfig)
    }
}

final class PostObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var body: String = ""
    @objc dynamic var author: UserObject?
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension PostObject: DomainConvertible {
    func asDomain() -> Post? {
        guard let authorsId = author?.id else { return nil }
        return Post(id: id, title: title, body: body, authorsId: authorsId)
    }
}


extension Post: RealmConvertible {
    func asRealmObject() -> PostObject {
        let postObject = PostObject()
        postObject.id = id
        postObject.title = title
        postObject.body = body
        return postObject
    }
}
