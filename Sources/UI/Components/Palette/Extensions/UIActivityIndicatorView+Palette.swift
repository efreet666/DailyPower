//
//  UIActivityIndicatorView+Palette.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 30.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {

    @IBInspectable private var paletteColor: String {
        get {
            return UIKitPaletteHelper.get()
        }
        set {
            UIKitPaletteHelper.set(value: newValue, from: Palette.colors) { color = $0 }
        }
    }
}
