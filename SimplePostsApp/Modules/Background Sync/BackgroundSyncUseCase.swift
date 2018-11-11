//
// Created by Adam Borek on 2018-11-11.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation

final class BackgroundSyncUseCase {
    private let apiClient: APIClientType
    init(apiClient: APIClientType) {
        self.apiClient = apiClient
    }

    func start() {
        _ = apiClient.invoke(GetUsersRequest())
            .subscribe()
    }
}
