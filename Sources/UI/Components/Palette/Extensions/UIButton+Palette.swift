//
//  UIButton+Palette.swift
//  DailyPower
//
//  Created by Michael Krasnenkov on 14.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

extension UIButton {

    @IBInspectable private var paletteFont: String {
        get {
            return UIKitPaletteHelper.get()
        }
        set {
            UIKitPaletteHelper.set(value: newValue, from: Palette.fonts) { titleLabel?.font = $0 }
        }
    }
}
