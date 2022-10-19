//
//  AuthorizationViewModel.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import XCoordinator

final class PasswordRecoveryViewModel: ModuleViewModel {

    // MARK: - Dependencies
    lazy var router: AnyRouter<EntranceRoute> = deferred()
    lazy var authService: PasswordRecoveryAuthService = deferred()
    lazy var errorHandlerProvider: ErrorHandlerProvider = deferred()
    lazy var emailValidators: [AnyDataValidator<String>] = deferred()

    // MARK: - ModuleViewModel
    struct Input {
        let performLogin: Signal<Void>
        let showAuthorization: Signal<Void>
        let emailText: Driver<String>
    }

    func setup(with input: Input) -> Disposable {
        let disposable = CompositeDisposable()

        let credentials = input.emailText

        credentials
            .map { !$0.isEmpty }
            .drive(canPerformLoginRelay)
            .disposed(with: disposable)

        let finishRoute = input.performLogin
            .withLatestFrom(credentials)
            .flatMapFirst { [weak self] credentials -> Signal<EntranceRoute> in
                let fallback = Signal<EntranceRoute>.empty()

                guard let this = self else {
                    return fallback
                }

                let pairs = [
                    (credentials, this.emailValidators)
                ]
                let validations = pairs.flatMap { value, validators in
                    return validators.map { $0.rx.validate(data: value) }
                }

                return Completable.concat(validations)
                    .andThen(this.authService.resetPassword1(email: credentials))
                    .andThen(Observable.just(.finish))
                    .retry(using: this.errorHandlerProvider)
                    .catchErrorJustComplete()
                    .trackActivity(this.activityTracker)
                    .asSignal(onErrorSignalWith: fallback)
            }

        Signal
            .merge(
                finishRoute,
                input.showAuthorization.map(to: .authorization)
            )
            .emit(to: Binder(self) {
                $0.router.trigger($1)
            })
            .disposed(with: disposable)

        return disposable
    }

    // MARK: - Public
    private(set) lazy var canPerformLogin = canPerformLoginRelay.asDriver()
    private(set) lazy var isBusy = activityTracker.asDriver()

    // MARK: - Private
    private let canPerformLoginRelay = BehaviorRelay(value: false)
    private let activityTracker = ActivityTracker()
}
