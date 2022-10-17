//
//  PasswordValidator.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 25.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct PasswordValidator: DataValidator {

    func validate(data: String) -> DataValidationResult {
        return type(of: self).passwordPredicate.evaluate(with: data) ? .success : .error(DataValidationError(.format, dataType: .password))
    }

    private static let passwordRegularExpression = "[A-Za-z0-9._%+-@]{6,64}"

    private static let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegularExpression)
}
