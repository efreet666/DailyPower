//
//  PlannerDataConduitAssembly.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 18/04/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class PlannerDataConduitAssembly: Assembly {

    // MARK: - Public
    var conduit: PlannerDataConduit {
        return define(scope: .prototype, init: PlannerDataConduit())
    }
}
