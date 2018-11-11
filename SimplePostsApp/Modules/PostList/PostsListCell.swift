//
//  PostsListCell.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 09/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import UIKit

final class PostsListCell: RxTableViewCell {
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorAvatarView: UIImageView!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var readingTimeLabel: UILabel!

    var viewModel: PostsListCellViewModelType? {
        didSet {
            disposeOldBinding()
            bind()
        }
    }

    private func bind() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        bodyLabel.text = viewModel.body
        authorLabel.text = viewModel.authorName
        createdDateLabel.text = viewModel.createdDate
        readingTimeLabel.text = viewModel.readTime
        viewModel.authorAvatar
                .drive(authorAvatarView.rx.image)
                .disposed(by: disposeBag)
        viewModel.picture
            .drive(pictureImageView.rx.image)
            .disposed(by: disposeBag)
    }
}

extension PostsListCell: XibBased {
    static let xibFileName = "PostsListCell"
}
