//
//  AlertsAppDelegateAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 21.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import UIKit

final class AlertsAppDelegateAssembly: Assembly {

    // MARK: - Public
    var appDelegate: AlertsAppDelegate {
        return define(scope: .lazySingleton, init: AlertsAppDelegate()) {
            $0.alertsWindow = self.alertsWindow
            return $0
        }
    }

    var alertsWindow: UIWindow {
        return define(scope: .lazySingleton, init: UIWindow()) {
            $0.windowLevel = .normal
            $0.backgroundColor = .clear
            $0.isHidden = true
            $0.rootViewController = self.alertsWindowRootViewControllerAssembly.viewController
            return $0
        }
    }

    // MARK: - Private
    private lazy var alertsWindowRootViewControllerAssembly: AlertsWindowRootViewControllerAssembly = context.assembly()
}
