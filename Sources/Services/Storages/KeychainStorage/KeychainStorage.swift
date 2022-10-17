//
//  KeychainStorage.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 05.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

final class KeychainStorage {

    // MARK: - Dependencies
    lazy var keychain: KeychainStorageKeychain = deferred()

    // MARK: - Public
    var accessGroup: String? {
        get {
            return queue.sync { keychain.accessGroup }
        }
        set (value) {
            queue.sync { keychain.accessGroup = value }
        }
    }

    func delete(_ key: String) {
        _ = queue.sync {
            keychain.delete(key)
        }
    }

    func set(_ value: String, forKey key: String) {
        _ = queue.sync {
            keychain.set(value, forKey: key)
        }
    }

    func set(_ value: Data, forKey key: String) {
        _ = queue.sync {
            keychain.set(value, forKey: key)
        }
    }

    func set(_ value: Bool, forKey key: String) {
        _ = queue.sync {
            keychain.set(value, forKey: key)
        }
    }

    func get(_ key: String) -> String? {
        return queue.sync { keychain.get(key) }
    }

    func get(_ key: String) -> Data? {
        return queue.sync { keychain.get(key) }
    }

    func get(_ key: String) -> Bool? {
        return queue.sync { keychain.get(key) }
    }

    // MARK: - Private
    private let queue = DispatchQueue(label: "KeychainStorage queue")
}

extension KeychainStorage: StorageCodableSupport {
}
