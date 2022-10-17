//
//  AuthServiceAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 07.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class AuthServiceAssembly: Assembly {

    // MARK: - Public
    var service: AuthService {
        return define(scope: .lazySingleton, init: AuthService()) {
            $0.networkClient = self.networkClient
            $0.appSettings = self.appSettingsAssembly.appSettings
            return $0
        }
    }

    // MARK: - Private
    private var networkClient: AuthServiceNetworkClient {
        return define(scope: .prototype, init: AuthServiceDefaultNetworkClient(performer: self.networkClientAssembly.networkClient))
    }

    private lazy var networkClientAssembly: NetworkClientAssembly = context.assembly()
    private lazy var appSettingsAssembly: AppSettingsAssembly = context.assembly()
}
