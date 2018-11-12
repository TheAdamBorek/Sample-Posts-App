//
//  GetPostsListUseCase.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import RxSwift

final class GetPostsListUseCase {
    private let postStorage: PostsStorage

    init(postStorage: PostsStorage) {
        self.postStorage = postStorage
    }

    func posts() -> Observable<[Post]> {
        return postStorage.postsUpdates()
    }
}
