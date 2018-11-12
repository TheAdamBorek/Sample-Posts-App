//
// Created by Adam Borek on 2018-11-12.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation

extension JSONDecoder {
    func decode<T>(from data: Data) throws -> T where T : Decodable {
        return try decode(T.self, from: data)
    }
}
