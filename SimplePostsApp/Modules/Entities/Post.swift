//
//  Post.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation

typealias UserId = String

struct Post: Decodable {
    let id: Int
    let title: String
    let body: String
    let authorsId: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case authorsId = "userId"
    }
}
