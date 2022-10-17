//
//  EntranceCoordinatorAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 02.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import XCoordinator

final class EntranceCoordinatorAssembly: Assembly {

    // MARK: - Public
    func coordinator(parentRouter: AnyRouter<EntranceRoute.Parent>) -> EntranceCoordinator {
        return define(scope: .prototype, init: EntranceCoordinator()) {
            $0.parentRouter = parentRouter
            return $0
        }
    }
}
