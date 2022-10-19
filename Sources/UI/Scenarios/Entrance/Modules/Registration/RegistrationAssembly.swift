//
//  AuthorizationAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import XCoordinator

final class RegistrationAssembly: ViewControllerAssembly<RegistrationViewController, RegistrationViewModel> {

    // MARK: - Public
    func viewController(router: AnyRouter<EntranceRoute>) -> RegistrationViewController {
        return define(scope: .prototype, init: R.storyboard.registration.initial()!) {
            self.bindViewModel(to: $0) {
                $0.router = router
                $0.authService = self.authServiceAssembly.service
                $0.errorHandlerProvider = self.defaultErrorHandlerAssembly.defaultErrorHandler
                $0.emailValidators = self.emailValidators
                $0.passwordValidators = self.passwordValidators
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

    private var passwordValidators: [AnyDataValidator<String>] {
        return define(
            scope: .lazySingleton,
            init: [
                AnyDataValidator(self.lengthValidatorAssembly.validator(validRange: 6...20, dataType: .password)),
                AnyDataValidator(self.passwordValidatorAssembly.validator)
            ]
        )
    }

    private lazy var authServiceAssembly: AuthServiceAssembly = context.assembly()
    private lazy var defaultErrorHandlerAssembly: DefaultErrorHandlerAssembly = context.assembly()
    private lazy var lengthValidatorAssembly: LengthValidatorAssembly = context.assembly()
    private lazy var emailValidatorAssembly: EmailValidatorAssembly = context.assembly()
    private lazy var passwordValidatorAssembly: PasswordValidatorAssembly = context.assembly()
}
