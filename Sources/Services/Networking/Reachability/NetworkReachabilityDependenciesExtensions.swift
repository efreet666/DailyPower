//
//  NetworkReachabilityDependenciesExtensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Alamofire
import RxSwift

struct NetworkReachabilityAlamofireObservableFactory: NetworkReachabilityObservableFactory {

    enum Error: Swift.Error {
        case initializationFailure
    }

    func createObservable(for host: String) -> Observable<NetworkReachabilityStatus> {
        return Observable.create { observer in
            guard let manager = NetworkReachabilityManager(host: host), manager.startListening() else {
                observer.onError(Error.initializationFailure)
                return Disposables.create()
            }

            manager.listener = { status in
                if let status = NetworkReachabilityStatus(status) {
                    observer.onNext(status)
                }
            }

            if let status = NetworkReachabilityStatus(manager.networkReachabilityStatus) {
                observer.onNext(status)
            }

            return Disposables.create {
                manager.stopListening()
            }
        }
    }
}

private extension NetworkReachabilityStatus {

    init?(_ status: NetworkReachabilityManager.NetworkReachabilityStatus) {
        switch status {
        case .unknown:
            return nil
        case .notReachable:
            self = .notReachable
        case .reachable(.ethernetOrWiFi):
            self = .reachableOnWiFi
        case .reachable(.wwan):
            self = .reachableOnCellular
        }
    }
}
