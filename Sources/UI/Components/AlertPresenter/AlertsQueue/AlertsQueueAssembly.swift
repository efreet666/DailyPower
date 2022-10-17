//
//  AlertsQueueAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 22.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class AlertsQueueAssembly: Assembly {

    // MARK: - Public
    var alertsQueue: AlertsQueue {
        return define(scope: .lazySingleton, init: AlertsQueue()) {
            $0.window = self.alertsAppDelegateAssembly.alertsWindow
            return $0
        }
    }

    // MARK: - Private
    private lazy var alertsAppDelegateAssembly: AlertsAppDelegateAssembly = context.assembly()
}
