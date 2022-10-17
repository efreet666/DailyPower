//
//  UpdateTaskGroupNetworkRequest.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 26/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct UpdateTaskGroupNetworkRequest: NetworkRequest {

    let httpMethod: NetworkRequestHTTPMethod = .put
    let path: NetworkRequestPath
    let requiredAuthentication: NetworkRequestAuthenticationType = .token
    let taskParameters: NetworkRequestTaskParameters

    init(id: Int, name: String) {
        path = .relative("mobile/task-groups/\(id)")
        taskParameters = .general(parameters: [Key.name: name], parametersEncoding: .json)
    }

    private enum Key {
        static let name = "name"
    }
}
