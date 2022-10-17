//
//  NSLayoutConstraint+Palette.swift
//  DailyPower
//
//  Created by Michael Krasnenkov on 14.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {

    @IBInspectable private var paletteConstant: String {
        get {
            return UIKitPaletteHelper.get()
        }
        set {
            UIKitPaletteHelper.set(value: newValue, from: Palette.dimensions) { constant = $0 }
        }
    }
}
