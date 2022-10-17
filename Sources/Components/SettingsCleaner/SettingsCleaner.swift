//
//  SettingsCleaner.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 23/07/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

final class SettingsCleaner {

    // MARK: - Dependencies
    lazy var appSettings: SettingsCleanerAppSettings = deferred()

    // MARK: - Public
    func cleanSettingsIfNeeded() {
        guard appSettings.settingsCleaned == false else {
            return
        }

        appSettings.token = nil
        appSettings.settingsCleaned = true
    }
}
