//
//  TokenNetworkResponse.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 11.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

typealias TokenNetworkResponse = DecodableNetworkResponse<TokenDTO>

struct TokenDTO: Codable {

    enum CodingKeys: String, CodingKey {
        case token
        case refreshToken = "refresh_token"
    }

    let token: String
    let refreshToken: String
}
