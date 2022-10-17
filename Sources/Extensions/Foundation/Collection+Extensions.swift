//
//  Collection+Extensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 29.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

extension Collection {

    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
