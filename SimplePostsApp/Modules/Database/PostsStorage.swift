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
    func save(_ post: Post) throws
    func save(_ posts: [Post]) throws
}

//final class RealmPostsStorage: PostsStorage {
//    private let realmConfig = Realm.Configuration
//    init(realmConfig: Realm.Configuration) {
//        realmConfig = realmConfig
//    }
//
//    func save(_ post: Post) throws {
//        let realm = try Realm(configuration: realmConfig)
//        guard let author = realm.object(ofType: UserObject.self, forPrimaryKey: post.authorsId) else {
//            throw RelationshipError(message: "Author with id: \(post.authorsId) doesn't exists. Cannot link with the post \(post)")
//        }
//        let postObject = post.asRealmObject()
//        postObject.author = author
//        try realm.write {
//            realm.add(postObject, update: true)
//        }
//    }
//
//    func save(_ posts: [Post]) throws {
//        posts.forEach {
//            try? save($0)
//        }
//    }
//}

final class PostObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var body: String = ""
    @objc dynamic var author: UserObject?
    override class func primaryKey() -> String? {
        return "id"
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
