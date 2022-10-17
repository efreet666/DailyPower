//
//  NetworkHTTPHeaders.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 07.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation
import RxSwift

final class NetworkHTTPHeaders {

    // MARK: - Dependencies
    lazy var authDataProvider: NetworkHTTPHeadersAuthDataProvider = deferred()
    lazy var systemInfoProvider: NetworkHTTPHeadersSystemInfoProvider = deferred()

    // MARK: - Public
    func headers(for request: NetworkRequest) -> Single<[String: String]> {
        let headers = staticHeaders(for: request)
        return authHeaders(for: request).map { $0.map { $0.merged(with: headers) } ?? headers }
    }

    // MARK: - Private
    private enum HeaderName {
        static let appVersion = "X-App-Version"
        static let authorization = "Authorization"
    }

    private func staticHeaders(for request: NetworkRequest) -> [String: String] {
        let additionalHeaders = [
            HeaderName.appVersion: systemInfoProvider.appVersion
        ]
        return request.httpHeaders.merged(with: additionalHeaders)
    }

    private func authHeaders(for request: NetworkRequest) -> Single<[String: String]?> {
        switch request.requiredAuthentication {
        case .none:
            return .just(nil)
        case .token:
            return authDataProvider.accessToken.map {
                guard let token = $0 else {
                    throw NetworkError(.noAccessToken)
                }
                return [HeaderName.authorization: "Bearer \(token)"]
            }
        }
    }
}
