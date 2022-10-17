//
//  DataNetworkResponse.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 07.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct DataNetworkResponse {

    let payload: Data
    let metadata: NetworkRequestMetadata
}

extension DataNetworkResponse: NetworkResponse {

    static var dataType: NetworkResponseDataType {
        return .data
    }

    init?(rawData: Any?, metadata: NetworkRequestMetadata) {
        guard let payload = rawData as? Data, payload.isEmpty == false else {
            return nil
        }

        self.init(payload: payload, metadata: metadata)
    }
}
