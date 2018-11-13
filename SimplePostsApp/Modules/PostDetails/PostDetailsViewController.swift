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

protocol PostDetailsViewModelType {
    var postTitle: String { get }
    var postBody: String { get }
    var author: Driver<String> { get }
    var numberOfComments: Driver<String> { get }
}

final class PostDetailsViewModel: PostDetailsViewModelType {
    private let post: Post
    private let userUseCase = GetUserUseCase()
    private let commentsUseCase = GetCommentsUseCase()
    let author: Driver<String>
    let numberOfComments: Driver<String>

    init(post: Post) {
        self.post = post

        func serializeUserInfo(_ user: User) -> String {
            return "\(user.name), \(user.username), \(user.email)"
        }

        self.author = userUseCase.user(with: post.authorsId)
            .map(serializeUserInfo)
            .asDriver(onErrorJustReturn: "")

        self.numberOfComments = commentsUseCase.comments(for: post)
            .map { String(describing: $0.count) }
            .asDriver(onErrorJustReturn: "")
    }

    var postTitle: String {
        return post.title
    }

    var postBody: String {
        return post.body
    }
}
