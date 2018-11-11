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

    override func setUp() {
        super.setUp()
        apiClient = APIClientMock()
        backgroundSync = BackgroundSyncUseCase(apiClient: apiClient)
    }

    func test_invokeRequestToUsersEndpoint() {
        let usersRequest = GetUsersRequest()
        backgroundSync.start()
        apiClient.verify(didCall: usersRequest)
    }

    func test_savesUsersInDataBase() {
        backgroundSync.start()

    }
}
