//
//  ProfileDataConduitAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class ProfileDataConduitAssembly: Assembly {

    // MARK: - Public
    var conduit: ProfileDataConduit {
        return define(scope: .prototype, init: ProfileDataConduit())
    }

    // MARK: - Private
}
