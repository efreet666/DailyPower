//
//  NetworkClientDependencies.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 08.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

protocol NetworkClientTaskFactory {

    func task(for networkRequest: NetworkRequest) -> Single<NetworkTask>
}

protocol NetworkClientResponseMapper {

    func map<ResponseType: NetworkResponse>(input: NetworkResponseMapperInput) -> NetworkResponseMapperOutput<ResponseType>
}
