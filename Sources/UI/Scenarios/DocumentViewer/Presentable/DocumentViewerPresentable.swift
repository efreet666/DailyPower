//
//  DocumentViewerPresentable.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 22.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import XCoordinator

enum DocumentViewerRoute: Route {

    enum Parent: Route {
        case finish
    }

    case initial
    case finish
}

final class DocumentViewerStandaloneCoordinator: NavigationCoordinator<DocumentViewerRoute> {

    // MARK: - Dependencies
    lazy var parentRouter: AnyRouter<DocumentViewerRoute.Parent> = deferred()
    lazy var document: Document = deferred()

    // MARK: - Public
    init() {
        super.init(initialRoute: nil)
    }

    func configure() {
        trigger(.initial, with: TransitionOptions(animated: false))
    }

    // MARK: - Overrides
    override func prepareTransition(for route: DocumentViewerRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let module = documentViewerAssembly.viewController(router: anyRouter, document: document, isStandalone: true)
            return .set([module])
        case .finish:
            return .trigger(.finish, on: parentRouter)
        }
    }

    // MARK: - Private
    private lazy var documentViewerAssembly = DocumentViewerAssembly.instance()
}
