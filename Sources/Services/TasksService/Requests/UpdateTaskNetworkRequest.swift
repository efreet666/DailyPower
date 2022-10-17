//
//  UpdateTaskNetworkRequest.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 29/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct UpdateTaskNetworkRequest: NetworkRequest {

    let httpMethod: NetworkRequestHTTPMethod = .put
    let path: NetworkRequestPath
    let requiredAuthentication: NetworkRequestAuthenticationType = .token
    let taskParameters: NetworkRequestTaskParameters

    init(id: Int, name: String? = nil, isCompleted: Bool? = nil) {
        var parameters: [String: Any] = [:]

        if let name = name {
            parameters[Key.name] = name
        }
        if let isCompleted = isCompleted {
            parameters[Key.isCompleted] = isCompleted
        }

        path = .relative("mobile/tasks/\(id)")
        taskParameters = .general(parameters: parameters, parametersEncoding: .json)
    }

    private enum Key {
        static let name = "name"
        static let isCompleted = "isCompleted"
    }
}
