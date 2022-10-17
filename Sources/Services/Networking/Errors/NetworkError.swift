//
//  NetworkError.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 18.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct NetworkError: Error {

    enum Code {
        case noAccessToken
        case cannotMapResponse
        case serverError(ServerErrorDTO)
        case invalidURL
        case cannotEncodeRequest
        case unacceptableResponse
        case cannotSerializeResponse
    }

    let code: Code
    let underlyingError: Error?

    init(_ code: Code, underlyingError: Error? = nil) {
        self.code = code
        self.underlyingError = underlyingError
    }
}
