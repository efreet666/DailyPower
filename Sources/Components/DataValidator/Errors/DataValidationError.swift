//
//  DataValidationError.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 25.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct DataValidationError: Error {

    enum Code {
        case unknown
        case format
        case length
    }

    let code: Code
    let dataType: ValidatorDataType
    let underlyingError: Error?

    init(_ code: Code, dataType: ValidatorDataType, underlyingError: Error? = nil) {
        self.code = code
        self.dataType = dataType
        self.underlyingError = underlyingError
    }
}
