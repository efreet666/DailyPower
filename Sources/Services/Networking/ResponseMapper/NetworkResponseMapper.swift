//
//  NetworkResponseMapper.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 08.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct NetworkResponseMapper {

    func map<ResponseType: NetworkResponse>(input: NetworkResponseMapperInput) -> NetworkResponseMapperOutput<ResponseType> {
        let metadata = NetworkRequestMetadata(request: input.request, timeline: input.timeline)

        if let error = input.error {
            if let errorResponse = ErrorNetworkResponse(rawData: input.data, metadata: metadata) {
                return .error(NetworkError(.serverError(errorResponse.payload), underlyingError: error))
            } else {
                return .error(error)
            }
        }

        guard let response = ResponseType(rawData: input.data, metadata: metadata) else {
            return .error(NetworkError(.cannotMapResponse))
        }

        return .success(response)
    }
}
