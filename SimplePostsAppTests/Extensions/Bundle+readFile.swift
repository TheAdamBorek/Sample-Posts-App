//
// Created by Adam Borek on 2018-11-12.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
@testable import SimplePostsApp

extension Bundle {
    func read(contentOfFile file: String, ofType type: String) throws -> Data {
        guard let data = (path(forResource: file, ofType: type)
                .flatMap { FileManager.default.contents(atPath: $0) }) else {
            throw AnyError(debugMessage: "Cannot find \(file).\(type) in the bundle: \(self.bundlePath)")
        }
        return data
    }

    class func read(contentOfFile file: String, ofType type: String, inBundleForClass aClass: AnyClass) throws -> Data {
        let bundle = Bundle(for: aClass)
        return try bundle.read(contentOfFile: file, ofType: type)
    }
}
