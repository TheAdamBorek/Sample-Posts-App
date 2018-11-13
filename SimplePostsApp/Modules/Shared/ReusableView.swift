//
// Created by Adam Borek on 2018-11-10.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol ReusableView {
    static var reusableIdentifier: String { get }
}

extension UITableViewCell: ReusableView {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    func register<C: UITableViewCell>(cell: C.Type) where C: XibBased {
        self.register(C.xib, forCellReuseIdentifier: C.reusableIdentifier)
    }

    func dequeueCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell: Cell = dequeueReusableCell(withIdentifier: Cell.reusableIdentifier, for: indexPath) as? Cell else {
            fatalError("Cannot cast UITableViewCell to \(Cell.self)")
        }
        return cell
    }
}
