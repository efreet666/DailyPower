//
//  WorkoutsViewModel.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import XCoordinator

final class WorkoutsViewModel: ModuleViewModel {

    // MARK: - Dependencies
    lazy var router: AnyRouter<WorkoutsRoute> = deferred()

    // MARK: - ModuleViewModel
    struct Input {
    }

    func setup(with input: Input) -> Disposable {
        return Disposables.create()
    }

    // MARK: - Public

    // MARK: - Private
}
