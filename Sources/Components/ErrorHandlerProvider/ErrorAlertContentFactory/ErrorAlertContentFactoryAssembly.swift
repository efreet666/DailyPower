//
//  ErrorAlertContentFactoryAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 22.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class ErrorAlertContentFactoryAssembly: Assembly {

    // MARK: - Public
    var contentFactory: ErrorAlertContentFactory {
        return define(scope: .lazySingleton, init: ErrorAlertContentFactory())
    }
}
