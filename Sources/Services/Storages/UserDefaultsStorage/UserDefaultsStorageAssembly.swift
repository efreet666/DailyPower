//
//  UserDefaultsStorageAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 05.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class UserDefaultsStorageAssembly: Assembly {

    // MARK: - Public
    var userDefaultsStorage: UserDefaultsStorage {
        return define(scope: .lazySingleton, init: UserDefaultsStorage(UserDefaults.standard))
    }
}
