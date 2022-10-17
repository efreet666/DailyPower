//
//  TaskGroupDetailsAssembly.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 29/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import XCoordinator

final class TaskGroupDetailsAssembly: ViewControllerAssembly<TaskGroupDetailsViewController, TaskGroupDetailsViewModel> {

    // MARK: - Public
    func viewController(router: AnyRouter<PlannerRoute>, updateSink: Binder<Void>, taskGroup: TaskGroupDTO) -> TaskGroupDetailsViewController {
        return define(scope: .prototype, init: R.storyboard.taskGroupDetails.initial()!) {
            self.bindViewModel(to: $0) {
                $0.router = router
                $0.updateSink = updateSink
                $0.tasksService = self.tasksServiceAssembly.service
                $0.errorHandlerProvider = self.defaultErrorHandlerAssembly.defaultErrorHandler
                $0.alertPresenter = self.alertsQueueAssembly.alertsQueue
                $0.taskGroup = taskGroup
                $0.alerts = self.alerts
            }
            return $0
        }
    }

    // MARK: - Private
    private var alerts: TaskGroupDetailsAlerts {
        return define(scope: .lazySingleton, init: TaskGroupDetailsAlerts())
    }

    private lazy var alertsQueueAssembly: AlertsQueueAssembly = context.assembly()
    private lazy var tasksServiceAssembly: TasksServiceAssembly = context.assembly()
    private lazy var defaultErrorHandlerAssembly: DefaultErrorHandlerAssembly = context.assembly()
}
