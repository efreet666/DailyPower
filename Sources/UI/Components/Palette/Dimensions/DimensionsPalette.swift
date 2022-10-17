//
//  DimensionsPalette.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 13.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

class DimensionsPalette {

    var mainHorizontalInset: CGFloat {
        return 16
    }

    var mainCornerRadius: CGFloat {
        return 4
    }

    var mainBorderWidth: CGFloat {
        return 1
    }

    var auxBorderWidth: CGFloat {
        return 0.5
    }

    var buttonBorderWidth: CGFloat {
        return 2
    }

    var topTabBarLineHeight: CGFloat {
        return 2
    }

    var separatorLineHeight: CGFloat {
        return 0.5
    }
}

extension DimensionsPalette: PaletteComponent {

    enum Key: String {
        case mainHorizontalInset
        case mainCornerRadius
        case mainBorderWidth
        case buttonBorderWidth
        case topTabBarLineHeight
        case separatorLineHeight
        case auxBorderWidth
    }

    public func value(for key: Key) -> CGFloat {
        switch key {
        case .mainHorizontalInset:
            return mainHorizontalInset
        case .mainCornerRadius:
            return mainCornerRadius
        case .mainBorderWidth:
            return mainBorderWidth
        case .buttonBorderWidth:
            return buttonBorderWidth
        case .topTabBarLineHeight:
            return topTabBarLineHeight
        case .separatorLineHeight:
            return separatorLineHeight
        case .auxBorderWidth:
            return auxBorderWidth
        }
    }
}
