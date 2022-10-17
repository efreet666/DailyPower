//
//  NetworkReachabilityAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi

final class NetworkReachabilityAssembly: Assembly {

    // MARK: - Public
    var networkReachability: NetworkReachability {
        return define(scope: .lazySingleton, init: NetworkReachability()) {
            $0.observableFactory = self.observableFactory
            $0.host = self.host
            return $0
        }
    }

    // MARK: - Private
    private var host: String {
        return "ya.ru"
    }

    private var observableFactory: NetworkReachabilityObservableFactory {
        return define(scope: .lazySingleton, init: NetworkReachabilityAlamofireObservableFactory())
    }
}
