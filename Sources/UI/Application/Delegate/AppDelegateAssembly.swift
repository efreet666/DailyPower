//
//  AppDelegateAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import UIKit

final class AppDelegateAssembly: Assembly {

    // MARK: - Public
    var appDelegate: UIApplicationDelegate {
        return define(scope: .lazySingleton, init: AppDelegateProxy()) {
            $0.add(self.userInterfaceAppDelegateAssembly.appDelegate)
            $0.add(self.alertsAppDelegateAssembly.appDelegate)
            $0.add(self.playerAppDelegateAssembly.appDelegate)
            return $0
        }
    }

    // MARK: - Private
    private lazy var userInterfaceAppDelegateAssembly: UserInterfaceAppDelegateAssembly = context.assembly()
    private lazy var alertsAppDelegateAssembly: AlertsAppDelegateAssembly = context.assembly()
    private lazy var playerAppDelegateAssembly: PlayerAppDelegateAssembly = context.assembly()
}
