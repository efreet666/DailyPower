//
//  MainCoordinator.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 02.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import XCoordinator

enum MainRoute: Route {

    enum Parent: Route {
        case finish
    }

    case initial
}

final class MainCoordinator: TabBarCoordinator<MainRoute> {

    // MARK: - Dependencies
    lazy var parentRouter: AnyRouter<MainRoute.Parent> = deferred()

    // MARK: - Public
    init() {
        super.init(initialRoute: .initial)
    }

    // MARK: - Overrides
    override func prepareTransition(for route: MainRoute) -> TabBarTransition {
        switch route {
        case .initial:
            let tabs: [Presentable] = [
                plannerCoordinatorAssembly.coordinator(parentRouter: mapper()),
                nutritionCoordinatorAssembly.coordinator(parentRouter: mapper()),
                workoutsCoordinatorAssembly.coordinator(parentRouter: mapper()),
                motivationCoordinatorAssembly.coordinator(parentRouter: mapper()),
                profileCoordinatorAssembly.coordinator(parentRouter: mapper())
            ]
            return .multiple(.set(tabs), .select(index: 0))
        }
    }

    // MARK: - Private
    private func mapper() -> AnyRouter<PlannerRoute.Parent> {
        return mapper {
            switch $0 {
            case .finish:
                return .trigger(.finish, on: self.parentRouter)
            }
        }
    }

    private func mapper() -> AnyRouter<NutritionRoute.Parent> {
        return mapper {
            switch $0 {
            case .finish:
                return .trigger(.finish, on: self.parentRouter)
            }
        }
    }

    private func mapper() -> AnyRouter<WorkoutsRoute.Parent> {
        return mapper {
            switch $0 {
            case .finish:
                return .trigger(.finish, on: self.parentRouter)
            }
        }
    }

    private func mapper() -> AnyRouter<MotivationRoute.Parent> {
        return mapper {
            switch $0 {
            case .finish:
                return .trigger(.finish, on: self.parentRouter)
            }
        }
    }

    private func mapper() -> AnyRouter<ProfileRoute.Parent> {
        return mapper {
            switch $0 {
            case .finish:
                return .trigger(.finish, on: self.parentRouter)
            }
        }
    }

    private lazy var plannerCoordinatorAssembly = PlannerCoordinatorAssembly.instance()
    private lazy var nutritionCoordinatorAssembly = NutritionCoordinatorAssembly.instance()
    private lazy var workoutsCoordinatorAssembly = WorkoutsCoordinatorAssembly.instance()
    private lazy var motivationCoordinatorAssembly = MotivationCoordinatorAssembly.instance()
    private lazy var profileCoordinatorAssembly = ProfileCoordinatorAssembly.instance()
}
