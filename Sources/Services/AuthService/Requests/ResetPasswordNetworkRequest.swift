//
//  ResetPasswordNetworkRequest.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 22.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct ResetPasswordNetworkRequest: NetworkRequest {

    let httpMethod: NetworkRequestHTTPMethod = .post
    let path: NetworkRequestPath = .relative("mobile/resetting")
    let requiredAuthentication: NetworkRequestAuthenticationType = .none
    let taskParameters: NetworkRequestTaskParameters

    init(email: String) {
        taskParameters = .general(parameters: [Key.email: email], parametersEncoding: .json)
    }

    private enum Key {
        static let email = "email"
    }
}
