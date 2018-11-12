//
// Created by Adam Borek on 2018-11-12.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
protocol RealmConvertible {
    associatedtype RealmType
    func asRealmObject() -> RealmType
}
