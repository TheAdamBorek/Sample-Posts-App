//
// Created by Adam Borek on 2018-11-12.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import XCTest
@testable import SimplePostsApp

final class UserTests: XCTestCase {
    func test_testParsingOfUser() throws {
        let data = try Bundle.read(contentOfFile: "users_sample", ofType: "json", inBundleForClass: UserTests.self)
        let users: [User] = try JSONDecoder().decode(from: data)
        let user = users[0]
        XCTAssertEqual(user.id, "1")
        XCTAssertEqual(user.name, "Leanne Graham")
        XCTAssertEqual(user.username, "Bret")
        XCTAssertEqual(user.email, "Sincere@april.biz")
    }
}
