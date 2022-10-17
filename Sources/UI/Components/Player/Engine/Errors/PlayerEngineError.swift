//
//  PlayerEngineError.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct PlayerEngineError: Error {

    enum Code {
        case noInternet
        case itemLoadingFailed
        case unexpectedItemStatus
        case itemPlaybackFailed
        case playerFailed
    }

    let code: Code
    let underlyingError: Error?

    init(_ code: Code, underlyingError: Error? = nil) {
        self.code = code
        self.underlyingError = underlyingError
    }
}
