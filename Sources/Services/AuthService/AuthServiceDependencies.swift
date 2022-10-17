//
//  AuthServiceDependencies.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 07.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

protocol AuthServiceAppSettings: class {

    var token: Token? { get set }
    var tokenObservable: Observable<Token?> { get }
}

protocol AuthServiceNetworkClient {

    func performRequest(_ request: LoginNetworkRequest) -> Single<TokenNetworkResponse>
    func performRequest(_ request: RefreshTokenNetworkRequest) -> Single<TokenNetworkResponse>
    func performRequest(_ request: RegisterNetworkRequest) -> Single<TokenNetworkResponse>
    func performRequest(_ request: ResetPasswordNetworkRequest) -> Completable
}
