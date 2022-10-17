//
//  Routines.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

@discardableResult
func with<T>(_ object: T, do action: (T) -> Void) -> T {
    action(object)
    return object
}

func apply<T, R>(_ object: T, transform: (T) -> R) -> R {
    return transform(object)
}

func deferred<T>(file: StaticString = #file, line: UInt = #line) -> T {
    fatalError("Value isn't set before first use", file: file, line: line)
}

func abstractMethod(function: StaticString = #function, file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("Function \(String(describing: function)) must be overridden", file: file, line: line)
}

func notImplemented(function: StaticString = #function, file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("Function \(String(describing: function)) is not implemented yet", file: file, line: line)
}
