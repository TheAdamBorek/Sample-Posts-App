//
//  GenericRealm.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import RealmSwift

struct TransactionNotInitializedRealmError: Error { }
struct EntityNotFound: Error {
    let type: AnyClass
    let primaryKey: Any
}

public final class GenericRealm {
    private let realmConfig: Realm.Configuration
    private var transaction: Realm?

    public init(configuration: Realm.Configuration) {
        self.realmConfig = configuration
    }

    func object<T, KeyType>(forPrimaryKey key: KeyType) throws -> T
        where T: RealmConvertible, T.RealmType: DomainConvertible, T.RealmType.DomainType == T {
            let entity = try realm()
                .object(ofType: T.RealmType.self, forPrimaryKey: key)
                .flatMap { $0.asDomain() }
            guard let unwrapped = entity else {
                throw EntityNotFound(type: T.RealmType.self, primaryKey: key)
            }
            return unwrapped
    }

    func findAll<T>() throws -> [T]
        where T: RealmConvertible, T.RealmType: DomainConvertible, T.RealmType.DomainType == T {
            return try realm()
                .objects(T.RealmType.self)
                .asDomain()
    }

    func save<T>(_ object: T) throws where T: RealmConvertible {
        guard let transaction = self.transaction else {
            throw TransactionNotInitializedRealmError()
        }
        let realmObject = object.asRealmObject()
        transaction.add(realmObject, update: true)
    }

    func save<T>(_ objects: [T]) throws where T: RealmConvertible {
        guard let transaction = self.transaction else {
            throw TransactionNotInitializedRealmError()
        }
        let realmObjects = objects.map { $0.asRealmObject() }
        transaction.add(realmObjects, update: true)
    }

    func write(_ block: () throws -> ()) throws {
        transaction = try realm()
        try transaction?.write(block)
        transaction = nil
    }

    private func realm() throws -> Realm {
        return try Realm(configuration: realmConfig)
    }
}
