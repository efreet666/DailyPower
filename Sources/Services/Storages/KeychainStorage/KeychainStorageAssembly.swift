//
//  KeychainStorageAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 05.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import KeychainSwift

final class KeychainStorageAssembly: Assembly {

    // MARK: - Public
    var keychainStorage: KeychainStorage {
        return define(scope: .prototype, init: KeychainStorage()) {
            $0.keychain = self.keychain
            return $0
        }
    }

    // MARK: - Private
    private var keychain: KeychainStorageKeychain {
        return define(scope: .prototype, init: KeychainSwift(keyPrefix: ""))
    }
}
