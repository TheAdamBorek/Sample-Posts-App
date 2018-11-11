//
//  APIClient.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 11/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import RxSwift

enum APIClientError: Error {
    case statusCode(code: Int, data: Data?)
    case invalidURL(path: String)
    case encodingRequestError
}
typealias APIResponse = (HTTPURLResponse, Data)

protocol APIClientType {
    func invoke(_ components: URLRequestComponents) -> Single<APIResponse>
}

// I've decided to not use any 3rd party library for API connection. Mostly for 2 reasons:
// 1. Since URLSession was introduced, handling HTTP requests has stopped to be so painfull.
//   We don't need to use delegate syntax anymore so usually when I start a project I have my own implementation of APILayer.
//   Usually it's simple (contains ~200 LOC) and I've found no reason why to import a big dependency as Alamofire.
//   I'm not saying NO to Alamofire as I think is a great library but I think is too much for what I need here.
// 2. I wanted to show you that I'm able to write my own API layer. I wanted to show you how I split files, classes
//    & that I obey SOLID principles. Mostly Open-close principle in this case.
struct APIClient: APIClientType {
    private let hostURL: URL
    private let session: URLSession

    init(hostURL: URL,
         sessionConfiguration: URLSessionConfiguration = .default) {
        self.hostURL = hostURL
        self.session = URLSession(configuration: sessionConfiguration)
    }

    func invoke(_ components: URLRequestComponents) -> Single<APIResponse> {
        return Single.deferred {
            let urlRequest = try self.createUrlRequest(from: components)
            return self.send(urlRequest)
        }
    }

    private func send(_ urlRequest: URLRequest) -> Single<APIResponse> {
        return Single<APIResponse>.create { observer in
            let completionHandler = self.handleResponse(notify: observer)
            let task = self.session.dataTask(with: urlRequest, completionHandler: completionHandler)
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }

    typealias URLSessionCompletionHandler = (Data?, URLResponse?, Error?) -> Void
    private func handleResponse(notify observer: @escaping ((SingleEvent<APIResponse>) -> Void)) -> URLSessionCompletionHandler {
        func handleResponse(data: Data?, response: URLResponse?, error: Error?) {
            if let error = error { return observer(.error(error)) }
            guard let httpResponse = response as? HTTPURLResponse else {
                return observer(.error(error ?? AnyError(debugMessage: "no http response")))
            }
            guard httpResponse.isOK() else {
                return observer(.error(self.statusCodeError(httpResponse, data)))
            }
            let resultTuple = (httpResponse, data ?? Data())
            observer(.success(resultTuple))
        }
        return handleResponse
    }

    fileprivate func statusCodeError(_ httpResponse: HTTPURLResponse, _ data: Data?) -> APIClientError {
        return APIClientError.statusCode(code: httpResponse.statusCode, data: data ?? Data())
    }

    private func createUrlRequest(from components: URLRequestComponents) throws -> URLRequest {
        guard let url = URL(string: components.path, relativeTo: hostURL) else {
            throw APIClientError.invalidURL(path: components.path)
        }
        var urlRequest  = URLRequest(url: url)
        urlRequest.httpMethod = components.method.rawValue
        urlRequest.allHTTPHeaderFields = components.headers
        urlRequest = try components.encoding.encode(components: components, in: urlRequest)
        return urlRequest
    }
}

extension HTTPURLResponse {
    func isOK() -> Bool {
        return 200..<400 ~= statusCode
    }
}
