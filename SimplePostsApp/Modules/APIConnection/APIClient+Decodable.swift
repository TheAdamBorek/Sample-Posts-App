//
// Created by Adam Borek on 2018-11-12.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import RxSwift

extension APIClientType {
    func invoke<T: Decodable>(_ components: URLRequestComponents) -> Single<T> {
        return self.invoke(components)
            .map(parse)
    }

    private func parse<T: Decodable>(_ response: APIResponse) throws -> T {
        return try JSONDecoder().decode(from: response.1)
    }
}
