//
//  JSONNetworkResponse.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 07.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

protocol JSONMappable {

    init(json: [String: Any]) throws
}

struct JSONNetworkResponse<Payload: JSONMappable> {

    let payload: Payload
    let metadata: NetworkRequestMetadata
}

extension JSONNetworkResponse: NetworkResponse {

    static var dataType: NetworkResponseDataType {
        return .json
    }

    init?(rawData: Any?, metadata: NetworkRequestMetadata) {
        guard let json = rawData as? [String: Any] else {
            return nil
        }

        do {
            let payload = try Payload(json: json)
            self.init(payload: payload, metadata: metadata)
        } catch {
            assertionFailure("Failed to parse '\(Payload.self)' with error: \(error)")
            return nil
        }
    }
}
