//
// Created by Adam Borek on 2018-11-11.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import RxSwift

class SystemNotifications {
    private let notificationCenter = NotificationCenter.default
    var willEnterForeground: Observable<Void> {
        return notificationCenter.rx.notification(UIApplication.willEnterForegroundNotification)
            .mapTo(())
    }
}

final class BackgroundSyncUseCase {
    private typealias Resources = ([User], [Post], [Comment])
    private let apiClient: APIClientType
    private let storage: Storage
    private let notifications: SystemNotifications
    private var disposeBag = DisposeBag()

    init(notifications: SystemNotifications, apiClient: APIClientType, storage: Storage) {
        self.notifications = notifications
        self.apiClient = apiClient
        self.storage = storage
    }

    /**
     Starts backgroundSync.
     If you want to stop the behaviour don't forget to call stop.
     Making the object nil won't dispose this object
    */
    func start() {
        disposeBag = DisposeBag()
        notifications.willEnterForeground
            .startWith(())
            .flatMapFirst(downloadResources)
            .do(onNext: saveResources)
            .subscribe()
            .disposed(by: disposeBag)
    }

    func stop() {
        disposeBag = DisposeBag()
    }

    private func downloadResources() -> Observable<Resources>{
        return Single.zip(downloadUsers(), downloadPosts(), downloadComments()) { ($0, $1, $2) }
            .asObservable()
            .catchError { _ in return .empty() }
    }

    private func downloadUsers() -> Single<[User]> {
        return apiClient.invoke(GetUsersRequest())
    }

    private func downloadPosts() -> Single<[Post]> {
        return apiClient.invoke(GetPostsRequest())
    }

    private func downloadComments() -> Single<[Comment]> {
        return apiClient.invoke(GetCommentsRequst())
    }

    private func saveResources(users: [User], posts: [Post], comments: [Comment]) throws {
        try storage.save(users)
        try storage.save(posts)
        try storage.save(comments)
    }
}
