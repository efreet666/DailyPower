//
//  EmailValidator.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 25.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct EmailValidator: DataValidator {

    func validate(data: String) -> DataValidationResult {
        return type(of: self).emailPredicate.evaluate(with: data) ? .success : .error(DataValidationError(.format, dataType: .email))
    }

    private static let emailRegularExpression = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?" +
                                                "@" +
                                                "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}" +
                                                "[A-Za-z]{2,8}"

    private static let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegularExpression)
}
