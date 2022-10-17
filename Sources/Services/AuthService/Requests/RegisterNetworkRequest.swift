//
//  RegisterNetworkRequest.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 22.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct RegisterNetworkRequest: NetworkRequest {

    let httpMethod: NetworkRequestHTTPMethod = .post
    let path: NetworkRequestPath = .relative("mobile/register")
    let requiredAuthentication: NetworkRequestAuthenticationType = .none
    let taskParameters: NetworkRequestTaskParameters

    init(email: String, password: String) {
        taskParameters = .general(parameters: [Key.email: email, Key.password: password], parametersEncoding: .json)
    }

    private enum Key {
        static let email = "email"
        static let password = "password"
    }
}
