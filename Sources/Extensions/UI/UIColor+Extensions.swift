//
//  UIColor+Extensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 13.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(integralRed red: Int, green: Int, blue: Int, alpha: CGFloat = 1) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
    }

    convenience init(integralRed red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }

    convenience init(integralWhite white: Int, alpha: CGFloat = 1) {
        self.init(white: CGFloat(white) / 255, alpha: alpha)
    }

    convenience init(integralWhite white: CGFloat, alpha: CGFloat = 1) {
        self.init(white: white / 255, alpha: alpha)
    }
}
