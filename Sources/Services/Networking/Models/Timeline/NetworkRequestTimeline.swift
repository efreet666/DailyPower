//
//  NetworkRequestTimeline.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 08.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

protocol NetworkRequestTimeline {

    var requestStartTime: CFAbsoluteTime { get }
    var initialResponseTime: CFAbsoluteTime { get }
    var requestCompletedTime: CFAbsoluteTime { get }
    var serializationCompletedTime: CFAbsoluteTime { get }

    var latency: TimeInterval { get }
    var requestDuration: TimeInterval { get }
    var serializationDuration: TimeInterval { get }
    var totalDuration: TimeInterval { get }
}
