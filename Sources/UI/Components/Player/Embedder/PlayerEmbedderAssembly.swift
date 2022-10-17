//
//  PlayerEmbedderAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 17.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi

final class PlayerEmbedderAssembly: Assembly {

    // MARK: - Public
    func embedder<T: Equatable>() -> PlayerEmbedder<T> {
        return define(scope: .prototype, init: PlayerEmbedder<T>()) {
            $0.playerView = self.playerAssembly.playerView
            $0.playerWindow = self.playerAppDelegateAssembly.playerWindow
            $0.configure()
            return $0
        }
    }

    // MARK: - Private
    private lazy var playerAssembly: PlayerAssembly = context.assembly()
    private lazy var playerAppDelegateAssembly: PlayerAppDelegateAssembly = context.assembly()
}
