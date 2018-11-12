//
// Created by Adam Borek on 2018-11-11.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation


// An example of Open-close principle. Right now the app supports JSON & URL Encoding.
// When requirments change we can add new endocder without a need to modify already used encoders.
protocol ParameterEncoder {
    func encode(components: URLRequestComponents, in request: URLRequest) throws -> URLRequest
}

struct JSONEncoding: ParameterEncoder {
    func encode(components: URLRequestComponents, in request: URLRequest) throws -> URLRequest {
        var copy = request
        guard let params = components.parameters else { return request }
        let data = try JSONSerialization.data(withJSONObject: params)
        copy.httpBody = data
        return copy
    }
}

struct URLEncoding: ParameterEncoder {
    func encode(components: URLRequestComponents, in request: URLRequest) throws -> URLRequest {
        guard let baseURL = request.url else { throw APIClientError.encodingRequestError }
        var copy = request
        copy.url = try encodeURL(baseURL: baseURL, components: components)
        copy.httpBody = try encodeBody(for: components)
        return copy
    }

    private func encodeURL(baseURL: URL, components: URLRequestComponents) throws -> URL? {
        switch components.method {
        case .get:
            var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
            urlComponents?.queryItems = try createQueryItems(from: components.parameters)
            return urlComponents?.url
        default:
            return baseURL
        }
    }

    private func encodeBody(for components: URLRequestComponents) throws -> Data? {
        guard components.method != .get else {
            return nil
        }
        var urlComponents = URLComponents()
        urlComponents.queryItems = try createQueryItems(from: components.parameters)
        return urlComponents.query?.data(using: .utf8)
    }

    private func createQueryItems(from params: [String: Any]?) throws -> [URLQueryItem]? {
        return try params?
                .keys.sorted()
                     .map { key in
                         let value = params?[key]
                         switch value {
                         case let string as String:
                             return URLQueryItem(name: key, value: string)
                         case let integer as Int:
                             return URLQueryItem(name: key, value: String(integer))
                         case let bool as Bool:
                             return URLQueryItem(name: key, value: String(bool))
                         default:
                             throw APIClientError.encodingRequestError
                         }
                     }
    }
}

