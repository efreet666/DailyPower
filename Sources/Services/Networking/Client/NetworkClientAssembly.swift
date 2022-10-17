//
//  NetworkClientAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 08.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class NetworkClientAssembly: Assembly {

    // MARK: - Public
    var networkClient: NetworkClient {
        return define(scope: .lazySingleton, init: NetworkClient()) {
            $0.taskFactory = self.networkTaskFactoryAssembly.networkTaskFactory
            $0.responseMapper = self.responseMapper
            return $0
        }
    }

    // MARK: - Private
    private var responseMapper: NetworkClientResponseMapper {
        return define(scope: .lazySingleton, init: NetworkResponseMapper())
    }

    private lazy var networkTaskFactoryAssembly: NetworkTaskFactoryAssembly = context.assembly()
}
