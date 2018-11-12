//
// Created by Adam Borek on 2018-11-12.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
struct User: Decodable {
    private enum CodingKeys: CodingKey  {
        case id
        case name
        case username
        case email
    }

    let id: String
    let name: String
    let username: String
    let email: String
}

extension User {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        self.id = String(describing: id)
        self.name = try container.decode(String.self, forKey: .name)
        self.username = try container.decode(String.self, forKey: .username)
        self.email = try container.decode(String.self, forKey: .email)
    }
}
