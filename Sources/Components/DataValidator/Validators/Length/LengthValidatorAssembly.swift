//
//  LengthValidatorAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 25.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class LengthValidatorAssembly: Assembly {

    // MARK: - Public
    func validator(validRange: ClosedRange<Int>, dataType: ValidatorDataType = .generic) -> LengthValidator {
        return define(scope: .prototype, init: LengthValidator(validRange: validRange, dataType: dataType))
    }
}
