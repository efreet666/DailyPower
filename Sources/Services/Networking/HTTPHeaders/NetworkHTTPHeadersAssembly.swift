//
//  NetworkHTTPHeadersAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 07.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class NetworkHTTPHeadersAssembly: Assembly {

    // MARK: - Public
    var networkHTTPHeaders: NetworkHTTPHeaders {
        return define(scope: .lazySingleton, init: NetworkHTTPHeaders()) {
            $0.authDataProvider = self.authDataProvider
            $0.systemInfoProvider = self.systemInfoAssembly.systemInfo
            return $0
        }
    }

    // MARK: - Private
    private var authDataProvider: NetworkHTTPHeadersAuthDataProvider {
        return define(scope: .prototype, init: NetworkHTTPHeadersAuthServiceAuthDataProvider(authService: self.authServiceAssembly.service))
    }

    private lazy var authServiceAssembly: AuthServiceAssembly = context.assembly()
    private lazy var systemInfoAssembly: SystemInfoAssembly = context.assembly()
}
