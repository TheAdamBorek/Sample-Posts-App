//
// Created by Adam Borek on 2018-11-11.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import XCTest
import RxBlocking
import RxSwift
@testable import SimplePostsApp


// In this test I havn't mocked any other dependency used in the flow of sending a request.
// For example I havn't mocked the encoder in the FakeRequest. I wanted to test the behaviour of API layer no matter
// how class are split. Some developers could say it's an integration test. I think it's still a unit test.
// In my opinion we do a common mistatke in iOS industry by saying that UNIT test == CLASS test.
// UNIT can be more than that (UNIT != CLASS).
// As a result if we change implementation to Alamofire the test file wouldn't have to change. That's the point of test.
// Easy refactor.
// For more about my testing approach check the README.md file
final class APIClientTests: XCTestCase {
    var apiClient: APIClient!

    override func setUp() {
        super.setUp()
        MockURLProtocol.onSetUp()
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        apiClient = APIClient(hostURL: URL(string: "https://test.com")!,
                              sessionConfiguration: sessionConfiguration)
    }

    func testInvokeGetRequest() {
        let request = FakeRequest(method: .get, parameters: ["test": "testparam"], encoding: .url)
        let rawRequest = try! invoke(request)
        XCTAssertEqual(rawRequest?.httpMethod, request.method.rawValue.uppercased())
        XCTAssertEqual(rawRequest?.url?.path, request.path)
        expect(rawRequest, hasHeadersEqualsTo: request.headers)
        XCTAssertEqual(rawRequest?.url?.absoluteString, "https://test.com/path?test=testparam")
        XCTAssertNil(rawRequest?.httpBody)
    }

    func testInvokeGetWithoutParamsRequest() {
        let domainRequest = FakeRequest(method: .get)
        let rawRequest = try! invoke(domainRequest)
        XCTAssertEqual(rawRequest?.httpMethod, domainRequest.method.rawValue.uppercased())
        XCTAssertEqual(rawRequest?.url?.path, domainRequest.path)
        expect(rawRequest, hasHeadersEqualsTo: domainRequest.headers)
        XCTAssertEqual(rawRequest?.url?.absoluteString, "https://test.com/path")
    }

    func test_encodeIntegerParams_forGetRequest() {
        let domainRequest = FakeRequest(method: .get, parameters: ["int": 1, "int2": 2], encoding: .url)
        _ = try! apiClient.invoke(domainRequest).toBlocking().first()
        let rawRequest = MockURLProtocol.lastSentRequest
        XCTAssertEqual(rawRequest?.url?.absoluteString, "https://test.com/path?int=1&int2=2")
    }

    func test_encodeBoolParams_forGetRequest() {
        let domainRequest = FakeRequest(method: .get, parameters: ["bool": true, "bool2": false], encoding: .url)
        _ = try! apiClient.invoke(domainRequest).toBlocking().first()
        let rawRequest = MockURLProtocol.lastSentRequest
        XCTAssertEqual(rawRequest?.url?.absoluteString, "https://test.com/path?bool=true&bool2=false")
    }

    func testInvokePostRequest() {
        let domainRequest = FakeRequest(method: .post, parameters: ["id": 123, "object": "test"])
        _ = try! apiClient.invoke(domainRequest).toBlocking().first()
        var rawRequest = MockURLProtocol.lastSentRequest
        XCTAssertEqual(rawRequest?.httpMethod, domainRequest.method.rawValue.uppercased())
        XCTAssertEqual(rawRequest?.url?.path, domainRequest.path)
        expect(rawRequest, hasHeadersEqualsTo: domainRequest.headers)
        expect(rawRequest?.httpBody, toEqual: domainRequest.parameters)
        XCTAssertEqual(rawRequest?.url?.absoluteString, "https://test.com/path")
    }

    func testInvokePostWithoutParamsRequest() {
        let domainRequest = FakeRequest(method: .post)
        _ = try! apiClient.invoke(domainRequest).toBlocking().first()
        var rawRequest = MockURLProtocol.lastSentRequest
        XCTAssertEqual(rawRequest?.httpMethod, domainRequest.method.rawValue.uppercased())
        XCTAssertEqual(rawRequest?.url?.path, domainRequest.path)
        expect(rawRequest, hasHeadersEqualsTo: domainRequest.headers)
        expect(rawRequest?.httpBody, toEqual: domainRequest.parameters)
        XCTAssertEqual(rawRequest?.url?.absoluteString, "https://test.com/path")
    }

    func test_encodeIntegerParams_forPOSTRequest_ifURLEncoded() {
        let domainRequest = FakeRequest(method: .post, parameters: ["int": 1, "int2": 2], encoding: .url)
        let rawRequest = try! invoke(domainRequest)
        XCTAssertEqual(rawRequest?.url?.absoluteString, "https://test.com/path")
        expect(rawRequest?.httpBody, toEqual: "int=1&int2=2")
    }

    func test_encodeBoolParams_forPOSTRequest_ifURLEncoded() {
        let domainRequest = FakeRequest(method: .post, parameters: ["bool": true, "bool2": false], encoding: .url)
        let rawRequest = try! invoke(domainRequest)
        XCTAssertEqual(rawRequest?.url?.absoluteString, "https://test.com/path")
        expect(rawRequest?.httpBody, toEqual: "bool=true&bool2=false")
    }

    private func expect(_ data: Data?, toEqual json: [String: Any]?, file: StaticString = #file, line: UInt = #line) {
        switch (data, json) {
        case (.none, .none): ()
        // it's fine
        case (.some(let data), .some(let expected)):
             let paramsData = try? JSONSerialization.data(withJSONObject: expected)
            XCTAssertEqual(data, paramsData, file: file, line: line)
        default:
            XCTFail("\(String(describing: data)) is not equal to \(String(describing: json))", file: file, line: line)
        }
    }

    func testInvokePutRequest() {
        let domainRequest = FakeRequest(method: .put)
        _ = try! apiClient.invoke(domainRequest).toBlocking().first()
        let rawRequest = MockURLProtocol.lastSentRequest
        XCTAssertEqual(rawRequest?.httpMethod, domainRequest.method.rawValue.uppercased())
        XCTAssertEqual(rawRequest?.url?.path, domainRequest.path)
        expect(rawRequest, hasHeadersEqualsTo: domainRequest.headers)
        expect(rawRequest?.httpBody, toEqual: domainRequest.parameters)
        XCTAssertEqual(rawRequest?.url?.absoluteString, "https://test.com/path")
    }

    func testInvokeDeleteRequest() {
        let domainRequest = FakeRequest(method: .delete)
        _ = try! apiClient.invoke(domainRequest).toBlocking().first()
        let rawRequest = MockURLProtocol.lastSentRequest
        XCTAssertEqual(rawRequest?.httpMethod, domainRequest.method.rawValue.uppercased())
        XCTAssertEqual(rawRequest?.url?.path, domainRequest.path)
        expect(rawRequest, hasHeadersEqualsTo: domainRequest.headers)
        XCTAssertEqual(rawRequest?.url?.absoluteString, "https://test.com/path")
    }

    func expect(_ request: URLRequest?, hasHeadersEqualsTo expectedHeaders: [String: String]?,
                file: StaticString = #file, line: UInt = #line) {
        let headerAdddedByTheSystem = "Content-Length"
        var requestHeaders = request?.allHTTPHeaderFields ?? [:]
        _ = requestHeaders.removeValue(forKey: headerAdddedByTheSystem)
        let expected = expectedHeaders ?? [:]
        XCTAssertEqual(requestHeaders, expected, file: file, line: line)
    }

    func expect(_ data: Data?, toEqual string: String?, file: StaticString = #file, line: UInt = #line) {
        switch (data, string) {
        case (.none, .none): ()
            // it's fine
        case (.some(let data), .some(let expected)):
            let decoded = String(data: data, encoding: .utf8)
            XCTAssertEqual(decoded, expected, file: file, line: line)
        default:
            XCTFail("\(String(describing: data)) is not equal to \(String(describing: string))", file: file, line: line)
        }
    }

    func invoke(_ request: FakeRequest) throws -> URLRequest? {
        _ = try apiClient.invoke(request).toBlocking().first()
        return MockURLProtocol.lastSentRequest
    }
}

struct FakeRequest: URLRequestComponents {
    let method: HTTPMethod
    let path: String
    var headers: [String: String]?
    let parameters: [String: Any]?
    let encoding: ParameterEncoder

    init(method: HTTPMethod,
         path: String = "/path",
         headers: [String: String]? = nil,
         parameters: [String: Any]? = nil,
         encoding: ParameterEncoding = .json) {
        self.method = method
        self.path = path
        self.headers = headers
        self.parameters = parameters
        self.encoding = encoding.encoder
    }
}

public enum ParameterEncoding {
    case url
    case json

    var encoder: ParameterEncoder {
        switch self {
        case .url:
            return URLEncoding()
        case .json:
            return JSONEncoding()
        }
    }
}
