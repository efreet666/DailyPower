//
//  RefreshTokenNetworkRequest.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 11.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct RefreshTokenNetworkRequest: NetworkRequest {

    let httpMethod: NetworkRequestHTTPMethod = .post
    let path: NetworkRequestPath = .relative("token/refresh")
    let requiredAuthentication: NetworkRequestAuthenticationType = .none
    let taskParameters: NetworkRequestTaskParameters

    init(refreshToken: String) {
        taskParameters = .general(parameters: [Key.refreshToken: refreshToken], parametersEncoding: .json)
    }

    private enum Key {
        static let refreshToken = "refresh_token"
    }
}
