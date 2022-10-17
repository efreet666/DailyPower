//
//  CAMediaTimingFunction+Extensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 04.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

extension CAMediaTimingFunction {

    static var linear: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: .linear)
    }

    static var easeIn: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: .easeIn)
    }

    static var easeOut: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: .easeOut)
    }

    static var easeInEaseOut: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: .easeInEaseOut)
    }

    static var `default`: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: .default)
    }

    static func custom(_ c1x: Float, _ c1y: Float, _ c2x: Float, _ c2y: Float) -> CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: c1x, c1y, c2x, c2y)
    }
}
