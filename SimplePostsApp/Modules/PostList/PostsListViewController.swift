//
// Created by Adam Borek on 2018-11-09.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources
import RxCocoa
import RxSwift

final class PostsListViewController: BaseViewController {
    private enum Constants {
        static let screenTitle = "Posts".localized()
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(cell: PostsListCell.self)
        tableView.estimatedRowHeight = 200
        return tableView
    }()

    private let dataSource = RxTableViewSectionedReloadDataSource<PostsListSection>(configureCell: { _, tableView, indexPath, viewModel in
        let cell: PostsListCell = tableView.dequeueCell(for: indexPath)
        cell.viewModel = viewModel
        return cell
    })

    private let viewModel: PostsListViewModelType
    private let disposeBag = DisposeBag()

    init(viewModel: PostsListViewModelType = PostsListViewModel()) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.screenTitle
        view.backgroundColor = .white
        let margin = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.pinToEdges(of: self, margin: margin)
        viewModel.posts
                .map { [PostsListSection(items: $0)] }
                .drive(tableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
    }
}

struct PostsListSection: SectionModelType {
    private(set) var items: [PostsListCellViewModelType] = []

    init(original: PostsListSection, items: [PostsListCellViewModelType]) {
        self.items = items
    }

    init(items: [PostsListCellViewModelType]) {
        self.items = items
    }
}
