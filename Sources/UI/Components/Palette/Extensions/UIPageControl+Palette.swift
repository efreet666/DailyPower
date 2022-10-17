//
//  UIPageControl+Palette.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 09.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

extension UIPageControl {

    @IBInspectable private var palettePageIndicatorTintColor: String {
        get {
            return UIKitPaletteHelper.get()
        }
        set {
            UIKitPaletteHelper.set(value: newValue, from: Palette.colors) { pageIndicatorTintColor = $0 }
        }
    }

    @IBInspectable private var paletteCurrentPageIndicatorTintColor: String {
        get {
            return UIKitPaletteHelper.get()
        }
        set {
            UIKitPaletteHelper.set(value: newValue, from: Palette.colors) { currentPageIndicatorTintColor = $0 }
        }
    }
}
