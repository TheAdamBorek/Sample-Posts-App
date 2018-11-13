//
//  AnyError.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 11/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
struct AnyError: Swift.Error {
    public let file: StaticString
    public let function: StaticString
    public let line: UInt

    public let debugMessage: String
    public init(debugMessage: String = "",
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line) {
        self.debugMessage = debugMessage
        self.file = file
        self.function = function
        self.line = line
        debugPrint(self)
    }
}
