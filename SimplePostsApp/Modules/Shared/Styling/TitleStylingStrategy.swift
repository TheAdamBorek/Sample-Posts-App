//
// Created by Adam Borek on 2018-11-10.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import UIKit

protocol TitleStylingStrategy {
    func styleTitle(in viewController: UIViewController)
}

final class LargeTitleStyling: TitleStylingStrategy {
    func styleTitle(in viewController: UIViewController) {
        viewController.navigationController?.navigationBar.prefersLargeTitles = true
    }
}
