//
//  PostsTests.swift
//  SimplePostsAppTests
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import XCTest
@testable import SimplePostsApp

final class PostsTests: XCTestCase {
    func test_postParsing() throws {
        let data = try Bundle.read(contentOfFile: "posts_sample", ofType: "json", inBundleForClass: PostsTests.self)
        let posts: [Post] = try JSONDecoder().decode(from: data)
        let post = posts[0]
        XCTAssertEqual(post.id, 1)
        XCTAssertEqual(post.title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
        XCTAssertEqual(post.body, "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto")
        XCTAssertEqual(post.authorsId, 1)
    }
}
