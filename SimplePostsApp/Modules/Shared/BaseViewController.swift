//
// Created by Adam Borek on 2018-11-10.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    private let titleStyling: TitleStylingStrategy

    init(titleStyling: TitleStylingStrategy = LargeTitleStyling()) {
        self.titleStyling = titleStyling
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init with decoder is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleStyling.styleTitle(in: self)
    }
}


