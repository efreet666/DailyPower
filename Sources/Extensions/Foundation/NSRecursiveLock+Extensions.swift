//
//  NSRecursiveLock+Extensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 21.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

extension NSRecursiveLock {

    @discardableResult
    func performLocked<T>(action: () -> T) -> T {
        lock()
        defer { unlock() }

        return action()
    }
}
