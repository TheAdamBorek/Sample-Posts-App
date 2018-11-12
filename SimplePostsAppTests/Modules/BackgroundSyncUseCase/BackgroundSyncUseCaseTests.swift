//
// Created by Adam Borek on 2018-11-12.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import XCTest
import RxBlocking
import RxSwift
@testable import SimplePostsApp

final class BackgroundSyncUseCaseTests: XCTestCase {
    var backgroundSync: BackgroundSyncUseCase!
    var apiClient: APIClientMock!
    var userStorage: UserStorageSpy!

    override func setUp() {
        super.setUp()
        apiClient = APIClientMock()
        userStorage = UserStorageSpy()
        backgroundSync = BackgroundSyncUseCase(apiClient: apiClient, userStorage: userStorage)
    }

    func test_invokeRequestToUsersEndpoint() {
        let usersRequest = GetUsersRequest()
        backgroundSync.start()
        apiClient.verify(didCall: usersRequest)
    }

    func test_savesUsersInDatabase() throws {
        try apiClient.mock(contentOfFile: "users_sample", ofType: "json", asResponseFor: GetUsersRequest())
        backgroundSync.start()
        XCTAssertEqual(userStorage.users.count, 3)
    }
}
