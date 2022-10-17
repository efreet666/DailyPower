//
//  KeychainStorageDependencies.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 05.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

protocol KeychainStorageKeychain {

    var accessGroup: String? { get set }

    func delete(_ key: String) -> Bool

    func set(_ value: String, forKey key: String) -> Bool
    func set(_ value: Data, forKey key: String) -> Bool
    func set(_ value: Bool, forKey key: String) -> Bool

    func get(_ key: String) -> String?
    func get(_ key: String) -> Data?
    func get(_ key: String) -> Bool?
}
