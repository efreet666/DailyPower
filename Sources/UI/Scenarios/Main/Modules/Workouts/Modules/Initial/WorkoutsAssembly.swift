//
//  WorkoutsAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import XCoordinator

final class WorkoutsAssembly: ViewControllerAssembly<WorkoutsViewController, WorkoutsViewModel> {

    // MARK: - Public
    func viewController(router: AnyRouter<WorkoutsRoute>) -> WorkoutsViewController {
        return define(scope: .prototype, init: R.storyboard.workouts.initial()!) {
            self.bindViewModel(to: $0) {
                $0.router = router
            }
            return $0
        }
    }

    // MARK: - Private
}
