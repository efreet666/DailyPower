//
//  MotivationAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import XCoordinator

final class MotivationAssembly: ViewControllerAssembly<MotivationViewController, MotivationViewModel> {

    // MARK: - Public
    func viewController(router: AnyRouter<MotivationRoute>) -> MotivationViewController {
        return define(scope: .prototype, init: R.storyboard.motivation.initial()!) {
            $0.playerEmbedder = self.playerEmbedderAssembly.embedder()

            self.bindViewModel(to: $0) {
                $0.router = router
                $0.motivationsService = self.motivationsServiceAssembly.service
                $0.errorHandlerProvider = self.defaultErrorHandlerAssembly.defaultErrorHandler
            }

            return $0
        }
    }

    // MARK: - Private
    private lazy var motivationsServiceAssembly: MotivationsServiceAssembly = context.assembly()
    private lazy var defaultErrorHandlerAssembly: DefaultErrorHandlerAssembly = context.assembly()
    private lazy var playerEmbedderAssembly: PlayerEmbedderAssembly = context.assembly()
}
