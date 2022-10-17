//
//  KeychainStorageDependenciesExtensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 05.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import KeychainSwift

extension KeychainSwift: KeychainStorageKeychain {

    func set(_ value: String, forKey key: String) -> Bool {
        return set(value, forKey: key, withAccess: nil)
    }

    func set(_ value: Data, forKey key: String) -> Bool {
        return set(value, forKey: key, withAccess: nil)
    }

    func set(_ value: Bool, forKey key: String) -> Bool {
        return set(value, forKey: key, withAccess: nil)
    }

    func get(_ key: String) -> Data? {
        return getData(key)
    }

    func get(_ key: String) -> Bool? {
        return getBool(key)
    }
}
