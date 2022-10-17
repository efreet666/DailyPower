//
//  NSLayoutConstraint+Extensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 12.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {

    @IBInspectable var nativeConstant: CGFloat {
        get {
            return constant * UIScreen.main.scale
        }
        set {
            constant = newValue / UIScreen.main.scale
        }
    }
}
