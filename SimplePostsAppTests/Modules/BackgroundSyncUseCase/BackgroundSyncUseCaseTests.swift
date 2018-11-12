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
    var postsStorage: PostsStorageSpy!
    var commentsStorage: CommentsStorageSpy!
    var systemNotificationStub: SystemNotificationsMock!

    override func setUp() {
        super.setUp()
        apiClient = APIClientMock()
        userStorage = UserStorageSpy()
        postsStorage = PostsStorageSpy()
        commentsStorage = CommentsStorageSpy()
        systemNotificationStub = SystemNotificationsMock()
        backgroundSync = BackgroundSyncUseCase(notifications: systemNotificationStub,
                                               apiClient: apiClient,
                                               storage: storage)
    }

    var storage: Storage {
        return Storage(users: userStorage, posts: postsStorage, comments: commentsStorage)
    }

    func test_invokeRequestToUsersEndpoint() {
        let usersRequest = GetUsersRequest()
        backgroundSync.start()
        apiClient.verify(didCall: usersRequest)
    }

    func test_savesUsersInDatabase() throws {
        try mockAPIResponses()
        backgroundSync.start()
        XCTAssertEqual(userStorage.users.count, 3)
    }

    func test_invokeRequestToPostsEndpoint() {
        let postsRequests = GetPostsRequest()
        backgroundSync.start()
        apiClient.verify(didCall: postsRequests)
    }

    func test_savesPostsInDatabase() throws {
        try mockAPIResponses()
        backgroundSync.start()
        XCTAssertEqual(postsStorage.posts.count, 3)
    }

    func test_invokeRequestToCommentsEndpoint() throws {
        try mockAPIResponses()
        backgroundSync.start()
        apiClient.verify(didCall: GetCommentsRequst())
    }

    func test_savesCommentsInDatabase() throws {
        try mockAPIResponses()
        backgroundSync.start()
        XCTAssertEqual(commentsStorage.comments.count, 3)
    }

    func test_invokeSyncOnEveryAppEntry() throws {
        try mockAPIResponses()
        backgroundSync.start()
        systemNotificationStub.sendWillEnterForegroundNotification()
        apiClient.verify(didCall: GetPostsRequest(), times: 2)
        apiClient.verify(didCall: GetUsersRequest(), times: 2)
    }

    func test_ifServerRetunrsError_stillContinueTheBackgroundSync() throws {
        apiClient.mock(response: .failure(error: AnyError(), data: nil), for: GetUsersRequest())
        apiClient.mock(response: .failure(error: AnyError(), data: nil), for: GetPostsRequest())
        backgroundSync.start()
        systemNotificationStub.sendWillEnterForegroundNotification()
        apiClient.verify(didCall: GetPostsRequest(), times: 2)
        apiClient.verify(didCall: GetUsersRequest(), times: 2)
    }

    private func mockAPIResponses() throws {
        try apiClient.mock(contentOfFile: "users_sample", ofType: "json", asResponseFor: GetUsersRequest())
        try apiClient.mock(contentOfFile: "posts_sample", ofType: "json", asResponseFor: GetPostsRequest())
        try apiClient.mock(contentOfFile: "comments_sample", ofType: "json", asResponseFor: GetCommentsRequst())
    }
}
