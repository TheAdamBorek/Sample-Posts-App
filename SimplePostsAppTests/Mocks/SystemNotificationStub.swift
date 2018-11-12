//
//  SystemNotificationStub.swift
//  SimplePostsAppTests
//
//  Created by Adam Borek on 12/11/2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import RxSwift
@testable import SimplePostsApp

final class SystemNotificationsMock: SystemNotifications {
    private let willEnterForegroundSubject = PublishSubject<Void>()

    override var willEnterForeground: Observable<Void> {
        return willEnterForegroundSubject.asObservable()
    }

    func sendWillEnterForegroundNotification() {
        willEnterForegroundSubject.onNext(())
    }
}
