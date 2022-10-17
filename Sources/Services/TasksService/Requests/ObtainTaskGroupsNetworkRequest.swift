//
//  ObtainTaskGroupsNetworkRequest.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 26/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct ObtainTaskGroupsNetworkRequest: NetworkRequest {

    let httpMethod: NetworkRequestHTTPMethod = .get
    let path: NetworkRequestPath = .relative("mobile/task-groups")
    let requiredAuthentication: NetworkRequestAuthenticationType = .token
    let taskParameters: NetworkRequestTaskParameters = .general(parameters: nil, parametersEncoding: .default)
}
