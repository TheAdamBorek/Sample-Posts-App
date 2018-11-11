//
// Created by Adam Borek on 2018-11-11.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
protocol URLRequestComponents {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
    var encoding: ParameterEncoder { get }
}

public enum HTTPMethod: String {
    case get
    case head
    case post
    case put
    case delete
}

public enum ParameterEncoding {
    case url
    case json
}
