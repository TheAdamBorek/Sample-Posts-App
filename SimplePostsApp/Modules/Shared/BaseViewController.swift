//
// Created by Adam Borek on 2018-11-10.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import UIKit

// I think Base class is a code smell. It's dificult to maintain inheritance and additional
// features which are added while project is growing.
// However, Base class can also saves duplication. In such a case I use a Base class with Strategy pattrn
class BaseViewController: UIViewController {
    private let titleStyling: TitleStylingStrategy

    init(titleStyling: TitleStylingStrategy = LargeTitleStyling(), nibName: String? = nil, bundle: Bundle? = nil) {
        self.titleStyling = titleStyling
        super.init(nibName: nibName, bundle: bundle)
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


