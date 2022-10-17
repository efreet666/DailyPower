//
//  NutritionCoordinatorAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import XCoordinator

final class NutritionCoordinatorAssembly: Assembly {

    // MARK: - Public
    func coordinator(parentRouter: AnyRouter<NutritionRoute.Parent>) -> NutritionCoordinator {
        return define(scope: .prototype, init: NutritionCoordinator()) {
            $0.parentRouter = parentRouter
            $0.rootViewControllerConfigurator = self.navigationControllerConfiguratorAssembly.configurator(for: .nutrition)
            $0.configure()
            return $0
        }
    }

    // MARK: - Private
    private lazy var navigationControllerConfiguratorAssembly: MainTabNavigationControllerConfiguratorAssembly = context.assembly()
}
