//
//  TasksServiceAssembly.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 29/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class TasksServiceAssembly: Assembly {

    // MARK: - Public
    var service: TasksService {
        return define(scope: .lazySingleton, init: TasksService()) {
            $0.networkClient = self.networkClient
            return $0
        }
    }

    // MARK: - Private
    private var networkClient: TasksServiceNetworkClient {
        return define(scope: .prototype, init: TasksServiceDefaultNetworkClient(performer: self.networkClientAssembly.networkClient))
    }

    private lazy var networkClientAssembly: NetworkClientAssembly = context.assembly()
}
