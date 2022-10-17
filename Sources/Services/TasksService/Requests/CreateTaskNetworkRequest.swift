//
//  CreateTaskNetworkRequest.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 29/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct CreateTaskNetworkRequest: NetworkRequest {

    let httpMethod: NetworkRequestHTTPMethod = .post
    let path: NetworkRequestPath
    let requiredAuthentication: NetworkRequestAuthenticationType = .token
    let taskParameters: NetworkRequestTaskParameters

    init(groupID: Int, name: String) {
        path = .relative("mobile/task-groups/\(groupID)/tasks")
        taskParameters = .general(parameters: [Key.name: name], parametersEncoding: .json)
    }

    private enum Key {
        static let name = "name"
    }
}
