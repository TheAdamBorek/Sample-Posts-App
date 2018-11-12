//
//  Comment.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
struct Comment: Decodable {
    let id: Int
    let name: String
    let body: String
    let authorsEmail: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case body
        case authorsEmail = "email"
    }
}
