//
//  DataValidator.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 25.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

protocol DataValidator {

    associatedtype DataRepresentation

    func validate(data: DataRepresentation) -> DataValidationResult
}
