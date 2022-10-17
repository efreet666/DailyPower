//
//  MainTabNavigationControllerConfiguratorAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 12.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class MainTabNavigationControllerConfiguratorAssembly: Assembly {

    // MARK: - Public
    func configurator(for tab: MainTab) -> MainTabNavigationControllerConfigurator {
        return define(scope: .prototype, init: MainTabNavigationControllerConfigurator()) {
            $0.tab = tab
            return $0
        }
    }

    // MARK: - Private
}
