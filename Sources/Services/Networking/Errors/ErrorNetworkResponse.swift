//
//  ErrorNetworkResponse.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 07.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

typealias ErrorNetworkResponse = DecodableNetworkResponse<ServerErrorDTO>

struct ServerErrorDTO: Codable {

    enum CodingKeys: String, CodingKey {
        case code = "error"
        case message
    }

    enum Code: Equatable {
        case internalInconsistency
        case invalidParameters
        case userNotFound
        case userAlreadyExists
        case badCredentials
        case invalidToken
        case tokenExpired
        case unknown(Int)
    }

    let code: Code
    let message: String?
}

extension ServerErrorDTO.Code: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(RawValues.RawValue.self)

        switch rawValue {
        case RawValues.internalInconsistency.rawValue:
            self = .internalInconsistency
        case RawValues.invalidParameters.rawValue:
            self = .invalidParameters
        case RawValues.userNotFound.rawValue:
            self = .userNotFound
        case RawValues.userAlreadyExists.rawValue:
            self = .userAlreadyExists
        case RawValues.badCredentials.rawValue:
            self = .badCredentials
        case RawValues.invalidToken.rawValue:
            self = .invalidToken
        case RawValues.tokenExpired.rawValue:
            self = .tokenExpired
        default:
            self = .unknown(rawValue)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .internalInconsistency:
            try container.encode(RawValues.internalInconsistency.rawValue)
        case .invalidParameters:
            try container.encode(RawValues.invalidParameters.rawValue)
        case .userNotFound:
            try container.encode(RawValues.userNotFound.rawValue)
        case .userAlreadyExists:
            try container.encode(RawValues.userAlreadyExists.rawValue)
        case .badCredentials:
            try container.encode(RawValues.badCredentials.rawValue)
        case .invalidToken:
            try container.encode(RawValues.invalidToken.rawValue)
        case .tokenExpired:
            try container.encode(RawValues.tokenExpired.rawValue)
        case let .unknown(value):
            try container.encode(value)
        }
    }

    private enum RawValues: Int {
        case internalInconsistency = 1000
        case invalidParameters = 1001
        case userNotFound = 3000
        case userAlreadyExists = 3001
        case badCredentials = 3004
        case invalidToken = 3005
        case tokenExpired = 3007
    }
}
