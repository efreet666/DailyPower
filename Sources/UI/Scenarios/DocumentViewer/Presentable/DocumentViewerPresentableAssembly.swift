//
//  DocumentViewerPresentableAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 22.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import XCoordinator

final class DocumentViewerPresentableAssembly: Assembly {

    // MARK: - Public
    func presentable(for document: Document, parentRouter: AnyRouter<DocumentViewerRoute.Parent>) -> Presentable {
        return define(scope: .prototype, init: DocumentViewerStandaloneCoordinator()) {
            $0.document = document
            $0.parentRouter = parentRouter
            $0.configure()
            return $0
        }
    }

    func presentable(for document: Document) -> Presentable {
        return documentViewerAssembly.viewController(
            router: NullRouter<DocumentViewerRoute>().anyRouter,
            document: document,
            isStandalone: false
        )
    }

    // MARK: - Private
    private lazy var documentViewerAssembly: DocumentViewerAssembly = context.assembly()
}
