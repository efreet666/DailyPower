//
//  PlayerWindowRootViewControllerAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 12.08.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi

final class PlayerWindowRootViewControllerAssembly: Assembly {

    // MARK: - Public
    var viewController: PlayerWindowRootViewController {
        return define(scope: .prototype, init: PlayerWindowRootViewController())
    }
}
