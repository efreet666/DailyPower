//
//  UserProfileServiceAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 29.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class UserProfileServiceAssembly: Assembly {

    // MARK: - Public
    var service: UserProfileService {
        return define(scope: .lazySingleton, init: UserProfileService()) {
            $0.networkClient = self.networkClient
            return $0
        }
    }

    // MARK: - Private
    private var networkClient: UserProfileServiceNetworkClient {
        return define(scope: .prototype, init: UserProfileServiceDefaultNetworkClient(performer: self.networkClientAssembly.networkClient))
    }

    private lazy var networkClientAssembly: NetworkClientAssembly = context.assembly()
}
