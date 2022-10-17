//
//  DeleteTaskNetworkRequest.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 29/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct DeleteTaskNetworkRequest: NetworkRequest {

    let httpMethod: NetworkRequestHTTPMethod = .delete
    let path: NetworkRequestPath
    let requiredAuthentication: NetworkRequestAuthenticationType = .token
    let taskParameters: NetworkRequestTaskParameters = .general(parameters: nil, parametersEncoding: .default)

    init(id: Int) {
        path = .relative("mobile/tasks/\(id)")
    }
}
