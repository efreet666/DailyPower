//
//  PlannerAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 04.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import XCoordinator

final class PlannerAssembly: ViewControllerAssembly<PlannerViewController, PlannerViewModel> {

    // MARK: - Public
    func viewController(router: AnyRouter<PlannerRoute>, dataConduit: PlannerDataConduit) -> PlannerViewController {
        return define(scope: .prototype, init: R.storyboard.planner.initial()!) {
            self.bindViewModel(to: $0) {
                $0.router = router
                $0.tasksService = self.tasksServiceAssembly.service
                $0.errorHandlerProvider = self.defaultErrorHandlerAssembly.defaultErrorHandler
                $0.alertPresenter = self.alertsQueueAssembly.alertsQueue
                $0.updateProvider = self.updateProvider(with: dataConduit)
                $0.alerts = self.alerts
            }
            return $0
        }
    }

    // MARK: - Private
    private func updateProvider(with conduit: PlannerDataConduit) -> PlannerUpdateProvider {
        return define(scope: .prototype, init: PlannerDataConduitUpdateProvider(conduit: conduit))
    }

    private var alerts: PlannerAlerts {
        return define(scope: .lazySingleton, init: PlannerAlerts())
    }

    private lazy var alertsQueueAssembly: AlertsQueueAssembly = context.assembly()
    private lazy var tasksServiceAssembly: TasksServiceAssembly = context.assembly()
    private lazy var defaultErrorHandlerAssembly: DefaultErrorHandlerAssembly = context.assembly()
}
