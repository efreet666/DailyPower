//
//  NetworkReachability.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation
import RxSwift

final class NetworkReachability {

    // MARK: - Dependencies
    lazy var observableFactory: NetworkReachabilityObservableFactory = deferred()
    lazy var host: String = deferred()

    // MARK: - Public
    var networkReachabilityStatus: Observable<NetworkReachabilityStatus> {
        return status
    }

    // MARK: - Private
    private lazy var status = observableFactory.createObservable(for: host)
        .retryWhen {
            $0.flatMap { _ in
                Observable.just(()).delaySubscription(.seconds(10), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            }
        }
        .distinctUntilChanged()
        .share(replay: 1)
}
