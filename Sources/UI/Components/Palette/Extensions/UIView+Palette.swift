//
//  UIView+Palette.swift
//  DailyPower
//
//  Created by Michael Krasnenkov on 14.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable private var paletteBackgroundColor: String {
        get {
            return UIKitPaletteHelper.get()
        }
        set {
            UIKitPaletteHelper.set(value: newValue, from: Palette.colors) { backgroundColor = $0 }
        }
    }

    @IBInspectable private var paletteTintColor: String {
        get {
            return UIKitPaletteHelper.get()
        }
        set {
            UIKitPaletteHelper.set(value: newValue, from: Palette.colors) { tintColor = $0 }
        }
    }

    @IBInspectable private var paletteCornerRadius: String {
        get {
            return UIKitPaletteHelper.get()
        }
        set {
            UIKitPaletteHelper.set(value: newValue, from: Palette.dimensions) { layer.cornerRadius = $0 }
        }
    }

    @IBInspectable private var paletteBorderWidth: String {
        get {
            return UIKitPaletteHelper.get()
        }
        set {
            UIKitPaletteHelper.set(value: newValue, from: Palette.dimensions) { layer.borderWidth = $0 }
        }
    }

    @IBInspectable private var paletteBorderColor: String {
        get {
            return UIKitPaletteHelper.get()
        }
        set {
            UIKitPaletteHelper.set(value: newValue, from: Palette.colors) { layer.borderColor = $0.cgColor }
        }
    }
}
