//
//  DecodableNetworkResponse.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 07.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct DecodableNetworkResponse<Payload: Decodable> {

    let payload: Payload
    let metadata: NetworkRequestMetadata
}

extension DecodableNetworkResponse: NetworkResponse {

    static var dataType: NetworkResponseDataType {
        return .data
    }

    init?(rawData: Any?, metadata: NetworkRequestMetadata) {
        guard let data = rawData as? Data, data.isEmpty == false else {
            return nil
        }

        do {
            let payload = try JSONDecoder().decode(Payload.self, from: data)
            self.init(payload: payload, metadata: metadata)
        } catch {
            assertionFailure("Failed to decode '\(Payload.self)' with error: \(error)")
            return nil
        }
    }
}
