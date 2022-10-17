//
//  PlayerAppDelegateAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 11.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import UIKit

final class PlayerAppDelegateAssembly: Assembly {

    // MARK: - Public
    var appDelegate: PlayerAppDelegate {
        return define(scope: .lazySingleton, init: PlayerAppDelegate()) {
            $0.playerWindow = self.playerWindow
            return $0
        }
    }

    var playerWindow: UIWindow {
        return define(scope: .lazySingleton, init: UIWindow()) {
            $0.windowLevel = .normal
            $0.backgroundColor = .clear
            $0.isHidden = true
            $0.rootViewController = self.playerWindowRootViewControllerAssembly.viewController
            return $0
        }
    }

    // MARK: - Private
    private lazy var playerWindowRootViewControllerAssembly: PlayerWindowRootViewControllerAssembly = context.assembly()
}
