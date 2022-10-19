//
//  AuthorizationAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import XCoordinator

final class PasswordRecoveryAssembly: ViewControllerAssembly<PasswordRecoveryViewController, PasswordRecoveryViewModel> {

    // MARK: - Public
    func viewController(router: AnyRouter<EntranceRoute>) -> PasswordRecoveryViewController {
        return define(scope: .prototype, init: R.storyboard.passwordRecovery.initial()!) {
            self.bindViewModel(to: $0) {
                $0.router = router
                $0.authService = self.authServiceAssembly.service
                $0.errorHandlerProvider = self.defaultErrorHandlerAssembly.defaultErrorHandler
                $0.emailValidators = self.emailValidators
            }
            return $0
        }
    }

    // MARK: - Private
    private var emailValidators: [AnyDataValidator<String>] {
        return define(
            scope: .lazySingleton,
            init: [
                AnyDataValidator(self.lengthValidatorAssembly.validator(validRange: 6...64, dataType: .email)),
                AnyDataValidator(self.emailValidatorAssembly.validator)
            ]
        )
    }

    private lazy var authServiceAssembly: AuthServiceAssembly = context.assembly()
    private lazy var defaultErrorHandlerAssembly: DefaultErrorHandlerAssembly = context.assembly()
    private lazy var lengthValidatorAssembly: LengthValidatorAssembly = context.assembly()
    private lazy var emailValidatorAssembly: EmailValidatorAssembly = context.assembly()
}
