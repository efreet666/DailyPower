//
//  PlannerCoordinator.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 02.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import XCoordinator

enum PlannerRoute: Route {

    enum Parent: Route {
        case finish
    }

    case initial
    case taskGroupDetails(TaskGroupDTO)
    case finish
}

final class PlannerCoordinator: NavigationCoordinator<PlannerRoute> {

    // MARK: - Dependencies
    lazy var parentRouter: AnyRouter<PlannerRoute.Parent> = deferred()
    lazy var rootViewControllerConfigurator: PlannerCoordinatorRootViewControllerConfigurator = deferred()
    lazy var dataConduit: PlannerDataConduit = deferred()

    // MARK: - Public
    init() {
        super.init(initialRoute: nil)
    }

    func configure() {
        rootViewControllerConfigurator.configure(navigationController: rootViewController)
        trigger(.initial, with: TransitionOptions(animated: false))
    }

    // MARK: - Overrides
    override func prepareTransition(for route: PlannerRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let module = plannerAssembly.viewController(router: anyRouter, dataConduit: dataConduit)
            return .set([module])
        case let .taskGroupDetails(taskGroup):
            let sink = dataConduit.sink()
            let module = taskGroupDetailsAssembly.viewController(router: anyRouter, updateSink: sink, taskGroup: taskGroup)
            return .push(module)
        case .finish:
            return .trigger(.finish, on: parentRouter)
        }
    }

    // MARK: - Private
    private lazy var plannerAssembly = PlannerAssembly.instance()
    private lazy var taskGroupDetailsAssembly = TaskGroupDetailsAssembly.instance()
}
