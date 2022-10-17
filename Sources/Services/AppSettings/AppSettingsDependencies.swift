//
//  AppSettingsDependencies.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 05.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

protocol AppSettingsStorage {

    func delete(_ key: String)

    func set(_ value: String, forKey key: String)
    func set(_ value: Data, forKey key: String)
    func set(_ value: Bool, forKey key: String)
    func set<T: Encodable>(_ value: T, forKey key: String)

    func get(_ key: String) -> String?
    func get(_ key: String) -> Data?
    func get(_ key: String) -> Bool?
    func get<T: Decodable>(_ key: String) -> T?
}
