//
//  NetworkResponseMapperInput.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 08.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct NetworkResponseMapperInput {

    let data: Any?
    let error: Error?
    let request: NetworkRequest
    let timeline: NetworkRequestTimeline
}
