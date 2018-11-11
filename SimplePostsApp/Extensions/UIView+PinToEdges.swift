//
// Created by Adam Borek on 2018-11-10.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import UIKit

protocol ViewOwner {
    var view: UIView! { get }
}

extension UIView {
    func pinToEdges(of viewOwner: ViewOwner, margin: UIEdgeInsets = .zero) {
        guard let superView = viewOwner.view else { return }
        translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(self)
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: margin.left).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: margin.right * -1).isActive = true
        topAnchor.constraint(equalTo: superView.topAnchor, constant: margin.top).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: margin.bottom * -1).isActive = true
    }
}

extension UIViewController: ViewOwner { }
