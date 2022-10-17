//
//  UITextView+Palette.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 30.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

extension UITextView {

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
