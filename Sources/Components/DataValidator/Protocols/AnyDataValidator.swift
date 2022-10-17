//
//  AnyDataValidator.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 25.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct AnyDataValidator<T>: DataValidator {

    init<V: DataValidator>(_ validator: V) where V.DataRepresentation == T {
        validateClosure = validator.validate
    }

    func validate(data: T) -> DataValidationResult {
        return validateClosure(data)
    }

    private let validateClosure: (T) -> DataValidationResult
}
