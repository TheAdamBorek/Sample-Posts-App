//
// Created by Adam Borek on 2018-11-12.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
protocol UserStorage {
    func save(_ user: User) throws
    func save(_ users: [User]) throws
}
