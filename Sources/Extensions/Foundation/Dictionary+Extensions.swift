//
//  Dictionary+Extensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 07.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

extension Dictionary {

    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach {
            updateValue($0.value, forKey: $0.key)
        }
    }

    func merged(with dictionary: Dictionary) -> Dictionary {
        var result = self
        result.merge(with: dictionary)
        return result
    }
}
