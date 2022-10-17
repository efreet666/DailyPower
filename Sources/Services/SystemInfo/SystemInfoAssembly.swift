//
//  SystemInfoAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 07.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class SystemInfoAssembly: Assembly {

    // MARK: - Public
    var systemInfo: SystemInfo {
        return define(scope: .lazySingleton, init: SystemInfo())
    }

    // MARK: - Private
}
