//
//  GetCommentsUseCase.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 13/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import RxSwift

final class GetCommentsUseCase {
    private let storage: Storage
    init(storage: Storage = Storage()) {
        self.storage = storage
    }

    func comments(for post: Post) -> Single<[Comment]> {
        return Single.deferred {
            let comments = try self.storage.comments(for: post)
            return .just(comments)
        }
    }
}
