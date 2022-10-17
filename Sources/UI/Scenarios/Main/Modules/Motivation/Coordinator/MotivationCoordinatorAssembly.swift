//
//  MotivationCoordinatorAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import XCoordinator

final class MotivationCoordinatorAssembly: Assembly {

    // MARK: - Public
    func coordinator(parentRouter: AnyRouter<MotivationRoute.Parent>) -> MotivationCoordinator {
        return define(scope: .prototype, init: MotivationCoordinator()) {
            $0.parentRouter = parentRouter
            $0.rootViewControllerConfigurator = self.navigationControllerConfiguratorAssembly.configurator(for: .motivation)
            $0.configure()
            return $0
        }
    }

    // MARK: - Private
    private lazy var navigationControllerConfiguratorAssembly: MainTabNavigationControllerConfiguratorAssembly = context.assembly()
}
