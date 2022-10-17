//
//  SettingsCleanerAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 23/07/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi

final class SettingsCleanerAssembly: Assembly {

    // MARK: - Public
    var cleaner: SettingsCleaner {
        return define(scope: .lazySingleton, init: SettingsCleaner()) {
            $0.appSettings = self.appSettingsAssembly.appSettings
            return $0
        }
    }

    // MARK: - Private
    private lazy var appSettingsAssembly: AppSettingsAssembly = context.assembly()
}
