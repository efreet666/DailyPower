//
//  AVPlayerEngineDependenciesExtensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

extension AVPlayerView: AVPlayerEngineSurfaceViewRequirements {
}

extension AVPlayerItemFactory: AVPlayerEngineItemFactory {
}

extension AVPlayerItemPreloader: AVPlayerEngineItemPreloader {
}

struct AVPlayerEngineNetworkReachabilityConnectionChecker: AVPlayerEngineConnectionChecker {

    let reachability: NetworkReachability

    var isConnectionAvailable: Observable<Bool> {
        return reachability.networkReachabilityStatus.map { $0.isReachable }
    }
}
