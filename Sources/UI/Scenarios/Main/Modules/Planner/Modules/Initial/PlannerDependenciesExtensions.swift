//
//  PlannerDependenciesExtensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 04.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift

extension TasksService: PlannerTasksService {
}

struct PlannerDataConduitUpdateProvider: PlannerUpdateProvider {

    let conduit: PlannerDataConduit

    var updateData: Signal<Void> {
        return conduit.emitter()
    }
}
