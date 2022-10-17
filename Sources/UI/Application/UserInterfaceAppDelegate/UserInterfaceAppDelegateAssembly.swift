//
//  UserInterfaceAppDelegateAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation
import UIKit

final class UserInterfaceAppDelegateAssembly: Assembly {

    // MARK: - Public
    var appDelegate: UserInterfaceAppDelegate {
        return define(scope: .lazySingleton, init: UserInterfaceAppDelegate()) {
            $0.appCoordinator = self.appCoordinatorAssembly.coordinator
            $0.uiAppearanceConfigurator = self.uiAppearanceConfiguratorAssembly.configurator
            $0.mainWindow = self.mainWindow
            return $0
        }
    }

    var mainWindow: UIWindow {
        return define(scope: .lazySingleton, init: UIWindow())
    }

    // MARK: - Private
    private lazy var appCoordinatorAssembly: AppCoordinatorAssembly = context.assembly()
    private lazy var uiAppearanceConfiguratorAssembly: UIAppearanceConfiguratorAssembly = context.assembly()
}
