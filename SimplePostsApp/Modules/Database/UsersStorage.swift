//
// Created by Adam Borek on 2018-11-12.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import RealmSwift


protocol UsersStorage {
    func user(with id: Int) throws -> User
    func allUsers() throws -> [User]
    func save(_ user: User) throws
    func save(_ users: [User]) throws
}

final class RealmUsersStorage: UsersStorage {
    private let realm: GenericRealm
    init(realmConfig: Realm.Configuration = .defaultConfiguration) {
        self.realm = GenericRealm(configuration: realmConfig)
    }

    func user(with id: Int) throws -> User {
        return try realm.object(forPrimaryKey: id)
    }

    func allUsers() throws -> [User] {
        return try realm.findAll()
    }

    func save(_ user: User) throws {
        try realm.write {
            try realm.save(user)
        }
    }

    func save(_ users: [User]) throws {
        try realm.write {
            try realm.save(users)
        }
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

extension UserObject: DomainConvertible {
    func asDomain() -> User? {
        return User(id: id, name: name, username: username, email: email)
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
