//
//  Configuration.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
struct Configuration: Decodable {
    static let shared: Configuration = {
        guard let data = try? Bundle.main.read(contentOfFile: "Configuration", ofType: "plist") else {
            fatalError("Cannot read Configuration file")
        }
        return try! PropertyListDecoder().decode(Configuration.self, from: data)
    }()

    let host: URL

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let hostString = try container.decode(String.self, forKey: .host)
        guard let host = URL(string: hostString) else {
            throw AnyError(debugMessage: "Cannot parse hostURL")
        }
        self.host = host
    }

    private enum CodingKeys: String, CodingKey {
        case host
    }
}

