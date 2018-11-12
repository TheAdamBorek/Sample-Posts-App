//
//  CommentsTests.swift
//  SimplePostsAppTests
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
@testable import SimplePostsApp
import XCTest

final class CommentsTests: XCTestCase {
    func test_parsingComment() throws {
        let data = try Bundle.read(contentOfFile: "comments_sample", ofType: "json", inBundleForClass: CommentsTests.self)
        let comments: [Comment] = try JSONDecoder().decode(from: data)
        let comment = comments[0]
        XCTAssertEqual(comment.id, 1)
        XCTAssertEqual(comment.name, "id labore ex et quam laborum")
        XCTAssertEqual(comment.authorsEmail, "Eliseo@gardner.biz")
        XCTAssertEqual(comment.body, "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium")
    }
}
