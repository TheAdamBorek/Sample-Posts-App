//
// Created by Adam Borek on 2018-11-09.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
