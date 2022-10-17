//
//  PlayerAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 11.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

final class PlayerAssembly: ViewAssembly<PlayerView, PlayerViewModel> {

    // MARK: - Public
    var playerView: PlayerView {
        defineInjection(key: "engine", scope: .prototype, into: self.avPlayerEngineAssembly.engine)

        return define(scope: .prototype, init: R.nib.playerView(owner: nil)!) {
            $0.playerSurfaceViewProvider = self.engine
            $0.configure()

            self.bindViewModel(to: $0) {
                $0.engine = self.engine
                $0.interruptionEventsProvider = self.playerAppDelegateAssembly.appDelegate
                $0.configure()
            }

            return $0
        }
    }

    // MARK: - Private
    private var engine: AVPlayerEngine {
        return definePlaceholder(key: "engine")
    }

    private lazy var avPlayerEngineAssembly: AVPlayerEngineAssembly = context.assembly()
    private lazy var playerAppDelegateAssembly: PlayerAppDelegateAssembly = context.assembly()
}
