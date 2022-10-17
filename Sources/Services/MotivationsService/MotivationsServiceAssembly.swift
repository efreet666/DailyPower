//
//  MotivationsServiceAssembly.swift
//  DailyPower
//
//  Created by Artem Malyugin on 01/04/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class MotivationsServiceAssembly: Assembly {

    // MARK: - Public
    var service: MotivationsService {
        return define(scope: .lazySingleton, init: MotivationsService()) {
            $0.networkClient = self.networkClient
            return $0
        }
    }

    // MARK: - Private
    private var networkClient: MotivationsServiceNetworkClient {
        return define(scope: .prototype, init: MotivationsServiceDefaultNetworkClient(performer: self.networkClientAssembly.networkClient))
    }

    private lazy var networkClientAssembly: NetworkClientAssembly = context.assembly()
}
