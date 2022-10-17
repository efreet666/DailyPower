//
//  NetworkReachabilityDependencies.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

protocol NetworkReachabilityObservableFactory {

    func createObservable(for host: String) -> Observable<NetworkReachabilityStatus>
}
