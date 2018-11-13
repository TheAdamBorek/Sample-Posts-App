//
// Created by Adam Borek on 2018-11-12.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import UIKit

//taken from https://qualitycoding.org/ios-app-delegate-testing/
let appDelegateClass: AnyClass? =
        NSClassFromString("SimplePostsAppTests.UnitTestsAppDelegate") ?? AppDelegate.self
_ = UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass!))
