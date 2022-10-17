//
//  AVPlayerEngineAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import AVFoundation
import EasyDi

final class AVPlayerEngineAssembly: Assembly {

    // MARK: - Public
    var engine: AVPlayerEngine {
        defineInjection(key: "player", scope: .prototype, into: AVPlayer())

        return define(scope: .prototype, init: AVPlayerEngine()) {
            $0.player = self.player
            $0.playerView = self.playerView
            $0.playerItemFactory = self.playerItemFactory
            $0.playerItemPreloader = self.playerItemPreloader
            $0.connectionChecker = self.connectionChecker
            $0.configure()
            return $0
        }
    }

    // MARK: - Private
    private var player: AVPlayer {
        return definePlaceholder(key: "player")
    }

    private var playerView: AVPlayerEngineSurfaceView {
        return define(scope: .prototype, init: AVPlayerView()) {
            $0.player = self.player
            return $0
        }
    }

    private var playerItemFactory: AVPlayerEngineItemFactory {
        return define(scope: .lazySingleton, init: AVPlayerItemFactory())
    }

    private var playerItemPreloader: AVPlayerEngineItemPreloader {
        return define(scope: .lazySingleton, init: AVPlayerItemPreloader())
    }

    private var connectionChecker: AVPlayerEngineConnectionChecker {
        return define(
            scope: .prototype,
            init: AVPlayerEngineNetworkReachabilityConnectionChecker(reachability: self.networkReachabilityAssembly.networkReachability)
        )
    }

    private lazy var networkReachabilityAssembly: NetworkReachabilityAssembly = context.assembly()
}
