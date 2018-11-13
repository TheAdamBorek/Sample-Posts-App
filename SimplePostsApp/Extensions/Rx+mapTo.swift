//
//  Rx+mapTo.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    func mapTo<T>(_ value: T) -> Observable<T> {
        return map { _ in return value }
    }
}
