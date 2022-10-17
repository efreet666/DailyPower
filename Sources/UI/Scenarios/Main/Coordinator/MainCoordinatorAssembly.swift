//
//  MainCoordinatorAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 02.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import XCoordinator

final class MainCoordinatorAssembly: Assembly {

    // MARK: - Public
    func coordinator(parentRouter: AnyRouter<MainRoute.Parent>) -> MainCoordinator {
        return define(scope: .prototype, init: MainCoordinator()) {
            $0.parentRouter = parentRouter
            return $0
        }
    }
}
