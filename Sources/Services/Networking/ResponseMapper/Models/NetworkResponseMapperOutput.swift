//
//  NetworkResponseMapperOutput.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 08.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

enum NetworkResponseMapperOutput<ResponseType: NetworkResponse> {

    case error(Error)
    case success(ResponseType)
}
