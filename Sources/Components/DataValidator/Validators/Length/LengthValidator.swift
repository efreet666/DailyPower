//
//  LengthValidator.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 25.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct LengthValidator: DataValidator {

    let validRange: ClosedRange<Int>
    let dataType: ValidatorDataType

    func validate(data: String) -> DataValidationResult {
        return validRange.contains(data.count) ? .success : .error(DataValidationError(.length, dataType: dataType))
    }
}
