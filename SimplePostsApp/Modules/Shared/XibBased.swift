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

extension XibBased where Self: UIView {
    static func fromXib(translatesAutoresizingMaskIntoConstraints: Bool = true) -> Self {
        guard let view = Self.xib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("Cannot read from xib file")
        }
        view.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        return view
    }
}
