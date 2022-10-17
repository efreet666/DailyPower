//
//  StorageCodableSupport.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 05.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

protocol StorageCodableSupport {

    func get(_ key: String) -> Data?
    func set(_ value: Data, forKey key: String)
}

extension StorageCodableSupport {

    func get<T: Decodable>(_ key: String) -> T? {
        guard let data: Data = get(key) else {
            return nil
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            assertionFailure("Decoding value for key '\(key)' failed with error: \(error)")
            return nil
        }
    }

    func set<T: Encodable>(_ value: T, forKey key: String) {
        do {
            let coder = JSONEncoder()
            let data = try coder.encode(value)
            set(data, forKey: key)
        } catch {
            assertionFailure("Encoding value for key '\(key)' failed with error: \(error)")
            return
        }
    }
}
