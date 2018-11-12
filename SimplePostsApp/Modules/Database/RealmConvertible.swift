//
// Created by Adam Borek on 2018-11-12.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmConvertible {
    associatedtype RealmType: RealmSwift.Object
    func asRealmObject() -> RealmType
}

protocol DomainConvertible {
    associatedtype DomainType
    func asDomain() -> DomainType?
}

extension Results where Element: DomainConvertible {
    func asDomain() -> [Element.DomainType] {
        return self.compactMap { $0.asDomain() }
    }
}
