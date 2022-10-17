//
//  EntranceCoordinator.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 02.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import XCoordinator

enum EntranceRoute: Route {

    enum Parent: Route {
        case finish
    }

    case authorization
    case registration
    case passwordRecovery
    case userAgreement
    case privacyPolicy
    case finish
}

final class EntranceCoordinator: ViewCoordinator<EntranceRoute> {

    // MARK: - Dependencies
    lazy var parentRouter: AnyRouter<EntranceRoute.Parent> = deferred()

    // MARK: - Public
    init() {
        super.init(initialRoute: .authorization)
    }

    // MARK: - Overrides
    override func prepareTransition(for route: EntranceRoute) -> ViewTransition {
        switch route {
        case .authorization:
            return embedPresentable(authorizationAssembly.viewController(router: anyRouter))
        case .registration:
            return embedPresentable(registrationAssembly.viewController(router: anyRouter))
        case .passwordRecovery:
            return .none()
        case .userAgreement:
            let module = documentViewerPresentableAssembly.presentable(for: .userAgreement, parentRouter: mapper())
            return .present(module)
        case .privacyPolicy:
            let module = documentViewerPresentableAssembly.presentable(for: .privacyPolicy, parentRouter: mapper())
            return .present(module)
        case .finish:
            return .trigger(.finish, on: parentRouter)
        }
    }

    // MARK: - Private
    private func embedPresentable(_ presentable: ClassBoundPresentable) -> ViewTransition {
        defer {
            embeddedPresentable = presentable
        }

        if let embedded = embeddedPresentable {
            return .replace(embedded, with: presentable, in: rootViewController, animation: EmbedAnimation(type: .moveIn, subtype: .fromRight))
        } else {
            return .embed(presentable, in: rootViewController)
        }
    }

    private func mapper() -> AnyRouter<DocumentViewerRoute.Parent> {
        return mapper {
            switch $0 {
            case .finish:
                return .dismiss()
            }
        }
    }

    private weak var embeddedPresentable: ClassBoundPresentable?

    private lazy var authorizationAssembly = AuthorizationAssembly.instance()
    private lazy var documentViewerPresentableAssembly = DocumentViewerPresentableAssembly.instance()
    private lazy var registrationAssembly = RegistrationAssembly.instance()
}
