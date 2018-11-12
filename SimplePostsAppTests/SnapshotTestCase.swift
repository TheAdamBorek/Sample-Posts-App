//
//  SnapshotTestCase.swift
//  SimplePostsAppTests
//
//  Created by Adam Borek on 10/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import XCTest
import FBSnapshotTestCase

class SnapshotTestCase: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
    }
    enum ScreenSize: String {
        case iPhoneFive
        case iPhoneEight
        case iPhoneEightPlus
        case iPhoneX

        var bounds: CGRect {
            switch self {
            case .iPhoneFive:
                return CGRect(x: 0, y: 0, width: 320, height: 568)
            case .iPhoneEight:
                return CGRect(x: 0, y: 0, width: 375, height: 667)
            case .iPhoneEightPlus:
                return CGRect(x: 0, y: 0, width: 414, height: 736)
            case .iPhoneX:
                return CGRect(x: 0, y: 0, width: 414, height: 896)
            }
        }
    }

    private let frames: [ScreenSize] = [.iPhoneFive, .iPhoneEight, .iPhoneEightPlus, .iPhoneX]

    func verifyForScreens(view: UIView, file: StaticString = #file, line: UInt = #line) {
        frames.forEach { device in
            verify(view: view, frame: device.bounds, identifier: device.rawValue, file: file, line: line)
        }
    }


    func verify(view: UIView, frame: CGRect, identifier: String = "", file: StaticString = #file, line: UInt = #line) {
        view.frame = frame
        view.layoutIfNeeded()
        FBSnapshotVerifyView(view, identifier: identifier, file: file, line: line)
        FBSnapshotVerifyLayer(view.layer, identifier: identifier, file: file, line: line)
    }
}
