//
//  UILabel+Palette.swift
//  DailyPower
//
//  Created by Michael Krasnenkov on 14.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

extension UILabel {

    @IBInspectable private var paletteFont: String {
        get {
            return UIKitPaletteHelper.get()
        }
        set {
            UIKitPaletteHelper.set(value: newValue, from: Palette.fonts) { font = $0 }
        }
    }

    @IBInspectable private var paletteTextColor: String {
        get {
            return UIKitPaletteHelper.get()
        }
        set {
            UIKitPaletteHelper.set(value: newValue, from: Palette.colors) { textColor = $0 }
        }
    }
}
