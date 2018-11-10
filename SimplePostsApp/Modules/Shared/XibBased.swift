//
// Created by Adam Borek on 2018-11-10.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import UIKit

protocol XibBased {
    static var xibFileName: String { get }
}

extension XibBased {
    static var xib: UINib {
        return UINib(nibName: xibFileName, bundle: Bundle.main)
    }
}
