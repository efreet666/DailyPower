//
//  PlayerEngineState.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

enum PlayerEngineState {

    // состояние неизвестно
    case unknown
    // выполняется загрузка контента
    case loading
    // готов к воспроизведению
    case ready
    // все сломалось с ошибкой
    case failed(error: Error?)
}

extension PlayerEngineState {

    var isFailed: Bool {
        if case .failed = self {
            return true
        } else {
            return false
        }
    }

    var error: Error? {
        if case let .failed(error) = self {
            return error
        } else {
            return nil
        }
    }
}

extension PlayerEngineState: Equatable {

    static func == (lhs: PlayerEngineState, rhs: PlayerEngineState) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown), (.loading, .loading), (.ready, .ready), (.failed, .failed):
            return true
        default:
            return false
        }
    }
}
