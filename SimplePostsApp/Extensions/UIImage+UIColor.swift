//
// Created by Adam Borek on 2018-11-10.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static func image(withColor color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        paintBackground(of: rect, with: color)
        return renderTheImageFromContext()
    }

    private static func paintBackground(of rect: CGRect, with color: UIColor) {
        color.setFill()
        UIRectFill(rect)
    }

    private static func renderTheImageFromContext() -> UIImage {
        defer { UIGraphicsEndImageContext() }
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            assertionFailure("Cannot create an image from the context")
            return UIImage()
        }
        return image
    }
}
