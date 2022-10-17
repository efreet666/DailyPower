//
//  DocumentViewerAssembly.swift
//  DailyPower
//
//  Created by Artyom Malyugin on 28/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import XCoordinator

final class DocumentViewerAssembly: ViewControllerAssembly<DocumentViewerViewController, DocumentViewerViewModel> {

    // MARK: - Public
    func viewController(router: AnyRouter<DocumentViewerRoute>, document: Document, isStandalone: Bool) -> DocumentViewerViewController {
        return define(scope: .prototype, init: R.storyboard.documentViewer.initial()!) {
            $0.isStandalone = isStandalone
            $0.converter = self.rtfDocumentConverterAssembly.converter

            self.bindViewModel(to: $0) {
                $0.router = router
                $0.document = document
            }

            return $0
        }
    }

    // MARK: - Private
    private lazy var rtfDocumentConverterAssembly: RTFDocumentConverterAssembly = context.assembly()
}
