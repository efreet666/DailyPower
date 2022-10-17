//
//  NetworkHTTPHeadersDependenciesExtensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 07.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

struct NetworkHTTPHeadersAuthServiceAuthDataProvider: NetworkHTTPHeadersAuthDataProvider {

    let authService: AuthService

    var accessToken: Single<String?> {
        return authService.accessTokenObservable.take(1).asSingle()
    }
}

extension SystemInfo: NetworkHTTPHeadersSystemInfoProvider {
}
