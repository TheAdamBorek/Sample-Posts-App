//
//  MockURLProtocol.swift
//  SimplePostsAppTests
//
//  Created by Adam Borek on 11/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation

public class MockURLProtocol: URLProtocol {
    enum ConnectionResponse {
        case success(MockResponse)
        case error(NSError)
    }

    static var lastSentRequest: URLRequest?
    static var allSentRequests = [URLRequest]()

    static var connectionResponse: ConnectionResponse?

    override public class func canInit(with request: URLRequest) -> Bool {
        guard isHTTP(request) else {
            return false
        }
        return true
    }

    private class func isHTTP(_ request: URLRequest) -> Bool {
        return ["http", "https"].contains(request.url?.scheme ?? "")
    }

    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        var copy = request
        fixiOSBugOfEmptyHTTPBody(&copy)
        return copy
    }

    // https://stackoverflow.com/questions/36555018/why-is-the-httpbody-of-a-request-inside-an-nsurlprotocol-subclass-always-nil
    private class func fixiOSBugOfEmptyHTTPBody(_ request: inout URLRequest) {
        request.httpBody = request.httpBodyStream?.readfully()
    }

    override public func startLoading() {
        recordSentRequest()
        switch connectionResponse {
        case .success(let response):
            answer(with: response)

        case .error(let error):
            answer(with: error)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    private func recordSentRequest() {
        MockURLProtocol.lastSentRequest = request
        MockURLProtocol.allSentRequests.append(request)
    }

    var connectionResponse: ConnectionResponse {
        return MockURLProtocol.connectionResponse
            ?? ConnectionResponse.success(MockResponse(body: nil,
                                                       statusCode: 200,
                                                       httpVersion: nil,
                                                       headerFields: nil))
    }

    private func answer(with response: MockResponse) {
        let bodyData = response.body?.data(using: .utf8) ?? Data()
        let urlResponse = HTTPURLResponse(url: MockURLProtocol.lastSentRequest!.url!,
                                          statusCode: response.statusCode,
                                          httpVersion: response.httpVersion,
                                          headerFields: response.headerFields)
        client?.urlProtocol(self, didLoad: bodyData)
        client?.urlProtocol(self, didReceive: urlResponse!, cacheStoragePolicy: .notAllowed)
    }

    private func answer(with error: NSError) -> ()? {
        return client?.urlProtocol(self, didFailWithError: error)
    }

    public override func stopLoading() {
        // not supported
    }

    public static func onSetUp() {
        clear()
    }

    public static func clear() {
        lastSentRequest = nil
        connectionResponse = nil
        allSentRequests = []
    }

    /**
     *   Creates sessions configuration which has MockURLProtocol injected to intercept calls
     */
    static var sessionConfiguration: URLSessionConfiguration {
        let session = URLSessionConfiguration.default
        session.protocolClasses = [MockURLProtocol.self]
        return session
    }
}

extension InputStream {
    func readfully() -> Data {
        var result = Data()
        var buffer = [UInt8](repeating: 0, count: 4096)

        open()

        var amount = 0
        repeat {
            amount = read(&buffer, maxLength: buffer.count)
            if amount > 0 {
                result.append(buffer, count: amount)
            }
        } while amount > 0

        close()

        return result
    }
}

struct MockResponse {
    let body: String?
    let statusCode: Int
    let httpVersion: String?
    let headerFields: [String: String]?
}
