//
// Created by Adam Borek on 2018-11-12.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import RxSwift
import XCTest
@testable import SimplePostsApp

final class APIClientMock: APIClientType {
    private let baseURL = URL(string: "http://apiclientmock.com")!
    struct RequestsResponseIsNotMockedError: Error, LocalizedError {
        let request: URLRequestComponents
        var errorDescription: String? {
            return "There's no mocked response for \(request)"
        }
    }

    enum Response {
        case success(data: Data)
        case failure(error: Error, data: Data?)

        var data: Data {
            switch self {
            case .success(let data):
                return data
            case .failure(_, let data):
                return data ?? Data()
            }
        }
    }

    private var mockedResponses = [EquatableWrapper: Response]()
    private var invokedRequests = [URLRequestComponents]()

    func invoke(_ components: URLRequestComponents) -> Single<APIResponse> {
        return Single.deferred {
            self.invokedRequests.append(components)
            guard let response = self.findResponse(for: components) else {
                return Single<APIResponse>.error(RequestsResponseIsNotMockedError(request: components))
            }
            return self.answer(with: response, components: components)
        }
    }

    private func findResponse(for components: URLRequestComponents) -> Response? {
        let wrapper = EquatableWrapper(request: components)
        return mockedResponses[wrapper]
    }

    private func answer(with response: Response, components: URLRequestComponents) -> Single<APIResponse> {
        guard let url = URL(string: components.path, relativeTo: self.baseURL),
            let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "1.2", headerFields: nil) else {
                return .error(AnyError(debugMessage: "Cannot create HTTPURLResponse"))
        }
        return .just((urlResponse, response.data))
    }

    func mock(response: Response, for request: URLRequestComponents) {
        let wrapper = EquatableWrapper(request: request)
        mockedResponses[wrapper] = response
    }

    func mock(contentOfFile file: String, ofType aType: String, asResponseFor request: URLRequestComponents) throws {
        let bundle = Bundle(for: type(of: self).self)
        let data = try bundle.read(contentOfFile: file, ofType: aType)
        mock(response: .success(data: data), for: request)
    }

    func removeMockedResponse(for request: URLRequestComponents) {
        let wrapper = EquatableWrapper(request: request)
        mockedResponses.removeValue(forKey: wrapper)
    }

    func verify(didCall expectedRequest: URLRequestComponents, times: Int = 1, file: StaticString = #file, line: UInt = #line) {
        let invocationCount = invokedRequests.reduce(0) { accumulator, request in
            return request == expectedRequest ? accumulator + 1 : accumulator
        }
        XCTAssertEqual(invocationCount, times, file: file, line: line)
    }
}

private final class EquatableWrapper: Equatable, Hashable {
    let request: URLRequestComponents
    init(request: URLRequestComponents) {
        self.request = request
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(request.method)
        hasher.combine(request.path)
        if let encodedParams = try? EquatableWrapper.encodeParams(of: request) {
            hasher.combine(encodedParams)
        }
    }

    class func ==(lhs: EquatableWrapper, rhs: EquatableWrapper) -> Bool {
        do {
            let lhsParamsInJSON = try encodeParams(of: lhs.request)
            let rhsParamsInJSON = try encodeParams(of: rhs.request)
            return lhs.request.path == rhs.request.path &&
                lhs.request.method == rhs.request.method &&
                lhsParamsInJSON == rhsParamsInJSON
        } catch {
            return false
        }
    }

    private class func encodeParams(of request: URLRequestComponents) throws -> Data? {
        return try request.parameters.map { params in
            return try JSONSerialization.data(withJSONObject: params, options: .sortedKeys)
        }
    }
}

func ==(lhs: URLRequestComponents, rhs: URLRequestComponents) -> Bool {
    let lhsWrapper = EquatableWrapper(request: lhs)
    let rhsWrapper = EquatableWrapper(request: rhs)
    return lhsWrapper == rhsWrapper
}
