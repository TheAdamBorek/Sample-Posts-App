//
//  GetUserUseCase.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 13/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//
import RxSwift
import Foundation
final class GetUserUseCase {
    private let storage: Storage
    init(storage: Storage = Storage()) {
        self.storage = storage
    }

    func user(with id: Int) -> Single<User> {
        return Single.deferred {
            let user = try self.storage.user(with: id)
            return .just(user)
        }
    }
}
