//
//  NetworkTaskFactoryAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 08.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Alamofire
import EasyDi

final class NetworkTaskFactoryAssembly: Assembly {

    // MARK: - Public
    var networkTaskFactory: NetworkTaskFactory {
        return define(scope: .prototype, init: NetworkTaskFactory()) {
            $0.httpHeadersProvider = self.networkHTTPHeadersAssembly.networkHTTPHeaders
            $0.apiBaseURLProvider = self.apiBaseURLProvider
            $0.sessionManager = self.sessionManager
            return $0
        }
    }

    // MARK: - Private
    private var sessionManager: NetworkTaskFactorySessionManager {
        return define(scope: .prototype, init: NetworkTaskFactoryAlamofireSessionManager(sessionManager: self.alamofireSessionManager))
    }

    private var alamofireSessionManager: SessionManager {
        return define(
            scope: .prototype,
            init: SessionManager(
                configuration: with(URLSessionConfiguration.default) {
                    $0.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
                }
            ),
            inject: {
                $0.startRequestsImmediately = false
                return $0
            }
        )
    }

    private var apiBaseURLProvider: NetworkTaskFactoryAPIBaseURLProvider {
        return define(
            scope: .prototype,
            init: NetworkTaskFactoryAppSettingsAPIBaseURLProvider(appSettings: self.appSettingsAssembly.appSettings)
        )
    }

    private lazy var networkHTTPHeadersAssembly: NetworkHTTPHeadersAssembly = context.assembly()
    private lazy var appSettingsAssembly: AppSettingsAssembly = context.assembly()
}
