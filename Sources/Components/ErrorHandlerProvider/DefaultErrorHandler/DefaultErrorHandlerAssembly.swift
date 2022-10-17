//
//  DefaultErrorHandlerAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 22.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class DefaultErrorHandlerAssembly: Assembly {

    // MARK: - Public
    var defaultErrorHandler: DefaultErrorHandler {
        return define(scope: .lazySingleton, init: DefaultErrorHandler()) {
            $0.alertPresenter = self.alertsQueueAssembly.alertsQueue
            $0.errorAlertContentFactory = self.errorAlertContentFactoryAssembly.contentFactory
            $0.authService = self.authServiceAssembly.service
            return $0
        }
    }

    // MARK: - Private
    private lazy var alertsQueueAssembly: AlertsQueueAssembly = context.assembly()
    private lazy var errorAlertContentFactoryAssembly: ErrorAlertContentFactoryAssembly = context.assembly()
    private lazy var authServiceAssembly: AuthServiceAssembly = context.assembly()
}
