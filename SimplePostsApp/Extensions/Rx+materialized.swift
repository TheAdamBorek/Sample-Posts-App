//
//  Rx+materialized.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType where E: EventConvertible {
    func errors() -> Observable<Error> {
        return filter { $0.event.error != nil }
            .map { $0.event.error! }
    }

    func elemnts() -> Observable<E.ElementType> {
        return filter { $0.event.element != nil }
            .map { $0.event.element! }
    }
}
