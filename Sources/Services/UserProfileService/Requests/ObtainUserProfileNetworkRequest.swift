//
//  ObtainUserProfileNetworkRequest.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 28.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct ObtainUserProfileNetworkRequest: NetworkRequest {

    let httpMethod: NetworkRequestHTTPMethod = .get
    let path: NetworkRequestPath = .relative("mobile/profile")
    let requiredAuthentication: NetworkRequestAuthenticationType = .token
    let taskParameters: NetworkRequestTaskParameters = .general(parameters: nil, parametersEncoding: .default)
}
