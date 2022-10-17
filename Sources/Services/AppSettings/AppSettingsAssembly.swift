//
//  AppSettingsAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 05.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class AppSettingsAssembly: Assembly {

    // MARK: - Public
    var appSettings: AppSettings {
        return define(scope: .lazySingleton, init: AppSettings()) {
            $0.simpleStorage = self.userDefaultsStorageAssembly.userDefaultsStorage
            $0.secureStorage = self.keychainStorageAssembly.keychainStorage
            return $0
        }
    }

    // MARK: - Private
    private lazy var userDefaultsStorageAssembly: UserDefaultsStorageAssembly = context.assembly()
    private lazy var keychainStorageAssembly: KeychainStorageAssembly = context.assembly()
}
