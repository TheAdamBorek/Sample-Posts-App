//
// Created by Adam Borek on 2018-11-12.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import RealmSwift


protocol UsersStorage {
    func user(with id: Int) throws -> User
    func save(_ user: User) throws
    func save(_ users: [User]) throws
}

final class RealmUsersStorage: UsersStorage {
    private let realmConfig: Realm.Configuration
    init(realmConfig: Realm.Configuration) {
        self.realmConfig = realmConfig
    }

    func user(with id: Int) throws -> User {
        fatalError("not implemented yet")
    }

    func save(_ user: User) throws {
//        let userObject = user.asRealmObject()
//        let realm = try Realm(configuration: realmConfig)
//        try realm.write {
//            realm.add(userObject, update: true)
//        }
    }

    func save(_ users: [User]) throws {
    }
}

final class UserObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var email: String = ""
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension User: RealmConvertible {
    func asRealmObject() -> UserObject {
        let userObject = UserObject()
        userObject.id = id
        userObject.name = name
        userObject.username = username
        userObject.email = email
        return userObject
    }
}
