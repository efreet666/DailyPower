//
//  PlayerTime.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

enum PlayerTime: Equatable {

    case unknown
    case seconds(TimeInterval)
}

extension PlayerTime {

    var value: TimeInterval? {
        switch self {
        case let .seconds(value):
            return value
        case .unknown:
            return nil
        }
    }
}
