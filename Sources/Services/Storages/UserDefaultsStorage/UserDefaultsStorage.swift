//
//  UserDefaultsStorage.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 05.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

final class UserDefaultsStorage {

    // MARK: - Public
    init(_ userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func delete(_ key: String) {
        userDefaults.set(nil, forKey: key)
    }

    func set(_ value: String, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }

    func set(_ value: Data, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }

    func set(_ value: Bool, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }

    func get(_ key: String) -> String? {
        return userDefaults.object(forKey: key) as? String
    }

    func get(_ key: String) -> Data? {
        return userDefaults.object(forKey: key) as? Data
    }

    func get(_ key: String) -> Bool? {
        return userDefaults.object(forKey: key) as? Bool
    }

    // MARK: - Private
    private let userDefaults: UserDefaults
}

extension UserDefaultsStorage: StorageCodableSupport {
}
