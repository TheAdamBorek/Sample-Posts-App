//
//  Rx+mapMany.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType where E: Sequence {
    func mapMany<O>(_ transform: @escaping (E.Element) throws -> O) -> Observable<[O]> {
        return map { sequence in
            return try sequence.map(transform)
        }
    }
}
