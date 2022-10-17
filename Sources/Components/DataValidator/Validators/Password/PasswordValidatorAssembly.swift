//
//  PasswordValidatorAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 25.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class PasswordValidatorAssembly: Assembly {

    // MARK: - Public
    var validator: PasswordValidator {
        return define(scope: .lazySingleton, init: PasswordValidator())
    }
}
