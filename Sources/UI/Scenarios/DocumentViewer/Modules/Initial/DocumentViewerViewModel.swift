//
//  DocumentViewerViewModel.swift
//  DailyPower
//
//  Created by Artyom Malyugin on 28/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import XCoordinator

final class DocumentViewerViewModel: ModuleViewModel {

    // MARK: - Dependencies
    lazy var router: AnyRouter<DocumentViewerRoute> = deferred()
    lazy var document: Document = deferred()

    // MARK: - ModuleViewModel
    struct Input {
        let didTapClose: Signal<Void>
    }

    func setup(with input: Input) -> Disposable {
        return input.didTapClose
            .map(to: DocumentViewerRoute.finish)
            .emit(to: Binder(self) {
                $0.router.trigger($1)
            })
    }

    // MARK: - Public
    private(set) lazy var currentDocument = Driver.just(document)

    // MARK: - Private
}
