//
// Created by Adam Borek on 2018-11-13.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class PostDetailsViewController: BaseViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var numberOfComments: UILabel!

    private let viewModel: PostDetailsViewModelType
    private let disposeBag = DisposeBag()

    init(viewModel: PostDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "PostDetailsViewController", bundle: .main)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {
        bodyLabel.text = viewModel.postBody
        titleLabel.text = viewModel.postTitle
        
        viewModel.author
            .drive(authorLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.numberOfComments
            .drive(numberOfComments.rx.text)
            .disposed(by: disposeBag)
    }
}
