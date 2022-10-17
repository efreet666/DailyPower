//
//  AuthServiceDependenciesExtensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 07.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

extension AppSettings: AuthServiceAppSettings {
}

struct AuthServiceDefaultNetworkClient: AuthServiceNetworkClient {

    let performer: NetworkRequestPerformer

    func performRequest(_ request: LoginNetworkRequest) -> Single<TokenNetworkResponse> {
        return performer.performRequest(request)
    }

    func performRequest(_ request: RefreshTokenNetworkRequest) -> Single<TokenNetworkResponse> {
        return performer.performRequest(request)
    }

    func performRequest(_ request: RegisterNetworkRequest) -> Single<TokenNetworkResponse> {
        return performer.performRequest(request)
    }

    func performRequest(_ request: ResetPasswordNetworkRequest) -> Completable {
        return performer.performRequestWithEmptyResponse(request)
    }
}
