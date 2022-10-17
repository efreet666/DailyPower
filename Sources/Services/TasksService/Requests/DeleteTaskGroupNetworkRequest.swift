//
//  DeleteTaskGroupNetworkRequest.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 26/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct DeleteTaskGroupNetworkRequest: NetworkRequest {

    let httpMethod: NetworkRequestHTTPMethod = .delete
    let path: NetworkRequestPath
    let requiredAuthentication: NetworkRequestAuthenticationType = .token
    let taskParameters: NetworkRequestTaskParameters = .general(parameters: nil, parametersEncoding: .default)

    init(id: Int) {
        path = .relative("mobile/task-groups/\(id)")
    }
}
