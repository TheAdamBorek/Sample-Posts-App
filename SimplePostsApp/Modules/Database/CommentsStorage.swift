//
//  CommentsStorage.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
protocol CommentsStorage {
    func save(_ comment: Comment) throws
    func save(_ comments: [Comment]) throws
}
