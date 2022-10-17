//
//  EmptyNetworkResponse.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 07.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct EmptyNetworkResponse {

    let metadata: NetworkRequestMetadata
}

extension EmptyNetworkResponse: NetworkResponse {

    static var dataType: NetworkResponseDataType {
        return .empty
    }

    init?(rawData: Any?, metadata: NetworkRequestMetadata) {
        guard let data = rawData as? Data, data.isEmpty == true else {
            return nil
        }

        self.init(metadata: metadata)
    }
}
