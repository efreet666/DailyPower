//
//  ObtainTasksNetworkRequest.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 29/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct ObtainTasksNetworkRequest: NetworkRequest {

    let httpMethod: NetworkRequestHTTPMethod = .get
    let path: NetworkRequestPath
    let requiredAuthentication: NetworkRequestAuthenticationType = .token
    let taskParameters: NetworkRequestTaskParameters = .general(parameters: nil, parametersEncoding: .default)

    init(groupID: Int) {
        path = .relative("mobile/task-groups/\(groupID)/tasks")
    }
}
