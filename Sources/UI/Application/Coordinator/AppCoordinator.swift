//
//  AppCoordinator.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 02.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import XCoordinator

enum AppRoute: Route {

    case entrance
    case main
}

final class AppCoordinator: BaseCoordinator<AppRoute, Transition<AppRootViewController>> {

    // MARK: - Dependencies
    lazy var authService: AppCoordinatorAuthService = deferred()

    // MARK: - Public
    init() {
        super.init(initialRoute: nil)
    }

    func configure() {
        let route: AppRoute = authService.isLoggedIn ? .main : .entrance
        trigger(route, with: TransitionOptions(animated: false))
    }

    // MARK: - Overrides
    override func prepareTransition(for route: AppRoute) -> Transition<AppRootViewController> {
        switch route {
        case .entrance:
            return embedPresentable(entranceCoordinatorAssembly.coordinator(parentRouter: mapper()))
        case .main:
            return embedPresentable(mainCoordinatorAssembly.coordinator(parentRouter: mapper()))
        }
    }

    // MARK: - Private
    private func embedPresentable(_ presentable: ClassBoundPresentable) -> Transition<AppRootViewController> {
        defer {
            embeddedPresentable = presentable
        }

        if let embedded = embeddedPresentable {
            return .replace(embedded, with: presentable, in: rootViewController, animation: EmbedAnimation(type: .fade))
        } else {
            return .embed(presentable, in: rootViewController)
        }
    }

    private func mapper() -> AnyRouter<EntranceRoute.Parent> {
        return mapper {
            switch $0 {
            case .finish:
                return .route(.main, on: self)
            }
        }
    }

    private func mapper() -> AnyRouter<MainRoute.Parent> {
        return mapper {
            switch $0 {
            case .finish:
                return .route(.entrance, on: self)
            }
        }
    }

    private weak var embeddedPresentable: ClassBoundPresentable?

    private lazy var entranceCoordinatorAssembly = EntranceCoordinatorAssembly.instance()
    private lazy var mainCoordinatorAssembly = MainCoordinatorAssembly.instance()
}
