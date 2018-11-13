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
        tableView.estimatedRowHeight = 100
        return tableView
    }()

    private let dataSource = RxTableViewSectionedReloadDataSource<PostsListSection>(configureCell: { _, tableView, indexPath, viewModel in
        let cell: PostsListCell = tableView.dequeueCell(for: indexPath)
        cell.viewModel = viewModel
        return cell
    })

    private let viewModel: PostsListViewModelType
    private let disposeBag = DisposeBag()

    init(viewModel: PostsListViewModelType) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        applyTranslations()
        setupSubviews()
        bind()
    }

    private func applyTranslations() {
        title = Constants.screenTitle
    }

    private func setupSubviews() {
        let margin = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.pinToEdges(of: self, margin: margin)
    }

    private func bind() {
        viewModel.posts
            .map { [PostsListSection(items: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        viewModel.errorMessage
            .drive(onNext: { [weak self] message in
                self?.showError(with: message)
            })
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .do(onNext: { [tableView] index in
                tableView.deselectRow(at: index, animated: false)
            })
            .map { $0.row }
            .bind(to: viewModel.didTapAtIndex)
            .disposed(by: disposeBag)
    }

    private func showError(with message: String) {
        let alertView = UIAlertController(title: "Error".localized(), message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }))
        present(alertView, animated: true, completion: nil)
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
