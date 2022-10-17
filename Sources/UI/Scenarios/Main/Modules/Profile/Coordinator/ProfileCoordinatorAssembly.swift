//
//  ProfileCoordinatorAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 02.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import XCoordinator

final class ProfileCoordinatorAssembly: Assembly {

    // MARK: - Public
    func coordinator(parentRouter: AnyRouter<ProfileRoute.Parent>) -> ProfileCoordinator {
        return define(scope: .prototype, init: ProfileCoordinator()) {
            $0.parentRouter = parentRouter
            $0.rootViewControllerConfigurator = self.navigationControllerConfiguratorAssembly.configurator(for: .profile)
            $0.dataConduit = self.profileDataConduitAssembly.conduit
            $0.configure()
            return $0
        }
    }

    // MARK: - Private
    private lazy var navigationControllerConfiguratorAssembly: MainTabNavigationControllerConfiguratorAssembly = context.assembly()
    private lazy var profileDataConduitAssembly: ProfileDataConduitAssembly = context.assembly()
}
