//
//  NutritionCoordinator.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import XCoordinator

enum NutritionRoute: Route {

    enum Parent: Route {
        case finish
    }

    case initial
    case finish
}

final class NutritionCoordinator: NavigationCoordinator<NutritionRoute> {

    // MARK: - Dependencies
    lazy var parentRouter: AnyRouter<NutritionRoute.Parent> = deferred()
    lazy var rootViewControllerConfigurator: NutritionCoordinatorRootViewControllerConfigurator = deferred()

    // MARK: - Public
    init() {
        super.init(initialRoute: nil)
    }

    func configure() {
        rootViewControllerConfigurator.configure(navigationController: rootViewController)
        trigger(.initial, with: TransitionOptions(animated: false))
    }

    // MARK: - Overrides
    override func prepareTransition(for route: NutritionRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let module = nutritionAssembly.viewController(router: anyRouter)
            return .set([module])
        case .finish:
            return .trigger(.finish, on: parentRouter)
        }
    }

    // MARK: - Private
    private lazy var nutritionAssembly = NutritionAssembly.instance()
}
