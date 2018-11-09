//
// Created by Adam Borek on 2018-11-09.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import UIKit

final public class PostsListViewController: UIViewController {
    private enum Constants {
        static let screenTitle = "Posts".localized()
    }
    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init with decoder is not supported")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.screenTitle
    }
}
