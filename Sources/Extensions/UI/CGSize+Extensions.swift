//
//  CGSize+Extensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 04.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import CoreGraphics

extension CGSize {

    var integral: CGSize {
        return CGSize(width: ceil(abs(width)), height: ceil(abs(height)))
    }
}
