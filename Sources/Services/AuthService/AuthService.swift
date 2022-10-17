//
//  AuthService.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 07.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation
import RxSwift

final class AuthService {

    // MARK: - Dependencies
    lazy var networkClient: AuthServiceNetworkClient = deferred()
    lazy var appSettings: AuthServiceAppSettings = deferred()

    // MARK: - Public
    var isLoggedIn: Bool {
        return appSettings.token != nil
    }

    var isLoggedInObservable: Observable<Bool> {
        return appSettings.tokenObservable.map { $0 != nil }
    }

    var accessTokenObservable: Observable<String?> {
        return appSettings.tokenObservable.map { $0?.access }
    }

    func login(email: String, password: String) -> Completable {
        let request = LoginNetworkRequest(email: email, password: password)
        return networkClient.performRequest(request).payload().flatMapCompletable(saveToken)
    }

    func logout() -> Completable {
        return Completable.execute { [appSettings] in
            appSettings.token = nil
        }
    }

    func register(email: String, password: String) -> Completable {
        let request = RegisterNetworkRequest(email: email, password: password)
        return networkClient.performRequest(request).payload().flatMapCompletable(saveToken)
    }

    func refreshAccessToken() -> Completable {
        return refreshAccessTokenSharedCompletable
    }

    func resetPassword(email: String) -> Completable {
        let request = ResetPasswordNetworkRequest(email: email)
        return networkClient.performRequest(request)
    }

    // MARK: - Private
    private lazy var refreshAccessTokenSharedCompletable = appSettings.tokenObservable
        .take(1)
        .asSingle()
        .flatMapCompletable { [weak self] token in
            guard let this = self else {
                return .empty()
            }
            guard let refreshToken = token?.refresh else {
                throw AuthServiceError(.noRefreshToken)
            }

            let request = RefreshTokenNetworkRequest(refreshToken: refreshToken)
            return this.networkClient.performRequest(request).payload().flatMapCompletable(this.saveToken)
        }
        .asObservable()
        .share()
        .asCompletable()

    private lazy var saveToken = { [appSettings] (payload: TokenDTO) -> Completable in
        Completable.execute {
            appSettings.token = Token(access: payload.token, refresh: payload.refreshToken)
        }
    }
}
