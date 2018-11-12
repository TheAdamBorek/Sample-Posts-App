//
// Created by Adam Borek on 2018-11-11.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import RxSwift

final class BackgroundSyncUseCase {
    private let apiClient: APIClientType
    private let userStorage: UserStorage

    init(apiClient: APIClientType, userStorage: UserStorage) {
        self.apiClient = apiClient
        self.userStorage = userStorage
    }

    func start() {
        _ = apiClient.invoke(GetUsersRequest())
            .do(onSuccess: saveUsers)
            .subscribe()
    }

    private func saveUsers(_ users: [User]) throws {
        try userStorage.save(users)
    }
}
