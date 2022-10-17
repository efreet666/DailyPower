//
//  ObtainMotivationGroupsNetworkRequest.swift
//  DailyPower
//
//  Created by Artem Malyugin on 01/04/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct ObtainMotivationGroupsNetworkRequest: NetworkRequest {

    let httpMethod: NetworkRequestHTTPMethod = .get
    let path: NetworkRequestPath = .relative("mobile/motivations")
    let requiredAuthentication: NetworkRequestAuthenticationType = .token
    let taskParameters: NetworkRequestTaskParameters = .general(parameters: nil, parametersEncoding: .default)
}
