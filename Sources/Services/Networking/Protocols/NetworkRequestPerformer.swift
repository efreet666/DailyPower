//
//  NetworkRequestPerformer.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 11.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation
import RxSwift

protocol NetworkRequestPerformer {

    func performRequest<ResponseType: NetworkResponse>(_ request: NetworkRequest) -> Single<ResponseType>
}

extension NetworkRequestPerformer {

    func performRequestWithEmptyResponse(_ request: NetworkRequest) -> Completable {
        let response: Single<EmptyNetworkResponse> = performRequest(request)
        return response.asCompletable()
    }
}
