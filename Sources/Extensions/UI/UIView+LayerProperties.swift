//
//  UIView+LayerProperties.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import QuartzCore
import UIKit

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var nativeBorderWidth: CGFloat {
        get {
            return layer.borderWidth * UIScreen.main.scale
        }
        set {
            layer.borderWidth = newValue / UIScreen.main.scale
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColor.map { UIColor(cgColor: $0) }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable var shadowColor: UIColor? {
        get {
            return layer.shadowColor.map { UIColor(cgColor: $0) }
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
}
