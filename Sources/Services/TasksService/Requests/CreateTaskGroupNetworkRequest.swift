//
//  CreateTaskGroupNetworkRequest.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 26/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct CreateTaskGroupNetworkRequest: NetworkRequest {

    let httpMethod: NetworkRequestHTTPMethod = .post
    let path: NetworkRequestPath = .relative("mobile/task-groups")
    let requiredAuthentication: NetworkRequestAuthenticationType = .token
    let taskParameters: NetworkRequestTaskParameters

    init(name: String) {
        taskParameters = .general(parameters: [Key.name: name], parametersEncoding: .json)
    }

    private enum Key {
        static let name = "name"
    }
}
