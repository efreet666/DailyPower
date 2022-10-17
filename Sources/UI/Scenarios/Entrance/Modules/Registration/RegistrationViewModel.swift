//
//  RegistrationViewModel.swift
//  DailyPower
//
//  Created by Влад Бокин on 17.10.2022.
//  Copyright © 2022 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import XCoordinator

final class RegistrationViewModel: ModuleViewModel {

    // MARK: - Dependencies
    lazy var router: AnyRouter<EntranceRoute> = deferred()
    lazy var authService: AuthorizationAuthService = deferred()
    lazy var errorHandlerProvider: ErrorHandlerProvider = deferred()
    lazy var emailValidators: [AnyDataValidator<String>] = deferred()
    lazy var passwordValidators: [AnyDataValidator<String>] = deferred()

    // MARK: - ModuleViewModel
    struct Input {
        let performLogin: Signal<Void>
        let showRegistration: Signal<Void>
        let showPasswordRecovery: Signal<Void>
        let showUserAgreement: Signal<Void>
        let showPrivacyPolicy: Signal<Void>
        let emailText: Driver<String>
        let passwordText: Driver<String>
    }

    func setup(with input: Input) -> Disposable {
        let disposable = CompositeDisposable()

        let credentials = Driver.combineLatest(input.emailText, input.passwordText)

        credentials
            .map { !$0.0.isEmpty && !$0.1.isEmpty }
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
                    (credentials.0, this.emailValidators),
                    (credentials.1, this.passwordValidators)
                ]
                let validations = pairs.flatMap { value, validators in
                    return validators.map { $0.rx.validate(data: value) }
                }

                return Completable.concat(validations)
                    .andThen(this.authService.login(email: credentials.0, password: credentials.1))
                    .andThen(Observable.just(.finish))
                    .retry(using: this.errorHandlerProvider)
                    .catchErrorJustComplete()
                    .trackActivity(this.activityTracker)
                    .asSignal(onErrorSignalWith: fallback)
            }

        Signal
            .merge(
                finishRoute,
                input.showRegistration.map(to: .registration),
                input.showPasswordRecovery.map(to: .passwordRecovery),
                input.showUserAgreement.map(to: .userAgreement),
                input.showPrivacyPolicy.map(to: .privacyPolicy)
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
