//
//  PlannerCoordinatorAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 02.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import XCoordinator

final class PlannerCoordinatorAssembly: Assembly {

    // MARK: - Public
    func coordinator(parentRouter: AnyRouter<PlannerRoute.Parent>) -> PlannerCoordinator {
        return define(scope: .prototype, init: PlannerCoordinator()) {
            $0.parentRouter = parentRouter
            $0.rootViewControllerConfigurator = self.navigationControllerConfiguratorAssembly.configurator(for: .planner)
            $0.dataConduit = self.plannerDataConduitAssembly.conduit
            $0.configure()
            return $0
        }
    }

    // MARK: - Private
    private lazy var navigationControllerConfiguratorAssembly: MainTabNavigationControllerConfiguratorAssembly = context.assembly()
    private lazy var plannerDataConduitAssembly: PlannerDataConduitAssembly = context.assembly()
}
