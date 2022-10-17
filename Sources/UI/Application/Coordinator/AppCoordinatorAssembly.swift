//
//  AppCoordinatorAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 02.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi

final class AppCoordinatorAssembly: Assembly {

    // MARK: - Public
    var coordinator: AppCoordinator {
        return define(scope: .prototype, init: AppCoordinator()) {
            $0.authService = self.authServiceAssembly.service
            $0.configure()
            return $0
        }
    }

    // MARK: - Private
    private lazy var authServiceAssembly: AuthServiceAssembly = context.assembly()
}
