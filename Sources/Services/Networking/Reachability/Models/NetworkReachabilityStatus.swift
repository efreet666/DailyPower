//
//  NetworkReachabilityStatus.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

enum NetworkReachabilityStatus {

    case notReachable
    case reachableOnCellular
    case reachableOnWiFi
}

extension NetworkReachabilityStatus {

    var isReachable: Bool {
        switch self {
        case .notReachable:
            return false
        case .reachableOnCellular, .reachableOnWiFi:
            return true
        }
    }
}
