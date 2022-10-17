//
//  NetworkResponse.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 07.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

enum NetworkResponseDataType {

    case empty
    case json
    case data
}

struct NetworkRequestMetadata {

    let request: NetworkRequest
    let timeline: NetworkRequestTimeline
}

protocol NetworkResponse {

    static var dataType: NetworkResponseDataType { get }

    init?(rawData: Any?, metadata: NetworkRequestMetadata)

    var metadata: NetworkRequestMetadata { get }
}
