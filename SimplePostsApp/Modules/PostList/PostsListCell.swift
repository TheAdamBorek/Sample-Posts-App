//
//  PostsListCell.swift
//  SimplePostsApp
//
//  Created by Adam Borek on 09/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import UIKit

final class PostsListCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet private weak var authorStaticLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    var viewModel: PostsListCellViewModelType? {
        didSet {
            bind()
        }
    }

    private func bind() {
        authorStaticLabel.text = "Author".localized() + ":"
        titleLabel.text = viewModel?.title
        bodyLabel.text = viewModel?.body
        authorLabel.text = viewModel?.author
    }
}

extension PostsListCell: XibBased {
    static let xibFileName = "PostsListCell"
}
