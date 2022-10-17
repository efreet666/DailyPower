//
//  ColorsPalette.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 13.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

class ColorsPalette {

    var main: UIColor {
        return UIColor(integralRed: 0, green: 205, blue: 210)
    }

    var background: UIColor {
        return UIColor(integralRed: 28, green: 28, blue: 31)
    }

    var auxBackground1: UIColor {
        return UIColor(integralRed: 35, green: 35, blue: 40)
    }

    var auxBackground2: UIColor {
        return UIColor(integralRed: 55, green: 55, blue: 60)
    }

    var auxBackground3: UIColor {
        return UIColor(integralRed: 31, green: 31, blue: 35)
    }

    var topBarBackground: UIColor {
        return UIColor(integralRed: 28, green: 28, blue: 31)
    }

    var bottomBarBackground: UIColor {
        return UIColor(integralRed: 20, green: 20, blue: 22)
    }

    var editButton: UIColor {
        return UIColor(integralRed: 2, green: 186, blue: 191)
    }

    var deleteButton: UIColor {
        return UIColor(integralRed: 233, green: 76, blue: 76)
    }

    var bright: UIColor {
        return .white
    }

    var title: UIColor {
        return UIColor(integralWhite: 243)
    }

    var subtitle: UIColor {
        return UIColor(integralWhite: 184)
    }

    var common: UIColor {
        return UIColor(integralWhite: 105)
    }

    var dimmed: UIColor {
        return UIColor(integralWhite: 0, alpha: 0.25)
    }

    var pageIndicatorNormal: UIColor {
        return UIColor(integralRed: 73, green: 73, blue: 77)
    }

    var pageIndicatorCurrent: UIColor {
        return UIColor(integralWhite: 243)
    }
}

extension ColorsPalette: PaletteComponent {

    enum Key: String {
        case main
        case background
        case auxBackground1
        case auxBackground2
        case auxBackground3
        case topBarBackground
        case bottomBarBackground
        case editButton
        case deleteButton
        case bright
        case title
        case subtitle
        case common
        case dimmed
        case pageIndicatorNormal
        case pageIndicatorCurrent
    }

    // swiftlint:disable:next cyclomatic_complexity
    public func value(for key: Key) -> UIColor {
        switch key {
        case .main:
            return main
        case .background:
            return background
        case .auxBackground1:
            return auxBackground1
        case .auxBackground2:
            return auxBackground2
        case .auxBackground3:
            return auxBackground3
        case .topBarBackground:
            return topBarBackground
        case .bottomBarBackground:
            return bottomBarBackground
        case .editButton:
            return editButton
        case .deleteButton:
            return deleteButton
        case .bright:
            return bright
        case .title:
            return title
        case .subtitle:
            return subtitle
        case .common:
            return common
        case .dimmed:
            return dimmed
        case .pageIndicatorNormal:
            return pageIndicatorNormal
        case .pageIndicatorCurrent:
            return pageIndicatorCurrent
        }
    }
}
