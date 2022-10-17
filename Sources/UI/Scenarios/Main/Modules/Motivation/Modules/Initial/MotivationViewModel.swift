//
//  MotivationViewModel.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import XCoordinator

final class MotivationViewModel: ModuleViewModel {

    // MARK: - Dependencies
    lazy var router: AnyRouter<MotivationRoute> = deferred()
    lazy var motivationsService: MotivationMotivationsService = deferred()
    lazy var errorHandlerProvider: ErrorHandlerProvider = deferred()

    // MARK: - ModuleViewModel
    struct Input {
        let reloadMotivationGroup: Signal<Void>
    }

    func setup(with input: Input) -> Disposable {
        return input.reloadMotivationGroup.emit(to: reloadMotivationGroupRelay)
    }

    // MARK: - Public
    enum MotivationGroupState {
        case loading
        case content(MotivationGroupDTO)
        case error
    }

    private(set) lazy var motivationGroupState = reloadMotivationGroupRelay
        .startWith(())
        .flatMapLatest { [weak self] _ -> Observable<MotivationGroupState> in
            guard let this = self else {
                return .just(.error)
            }
            return this.obtainMotivationGroup
        }
        .asDriver(onError: .never)

    // MARK: - Private
    private lazy var obtainMotivationGroup: Observable<MotivationGroupState> = motivationsService.obtainMotivationGroups()
        .asObservable()
        .map { $0.first.map { .content($0) } ?? .error }
        .retry(using: errorHandlerProvider)
        .catchErrorJustReturn(.error)
        .startWith(.loading)

    private let reloadMotivationGroupRelay = PublishRelay<Void>()
}
