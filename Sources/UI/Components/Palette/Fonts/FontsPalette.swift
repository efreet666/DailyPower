//
//  FontsPalette.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 13.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

class FontsPalette {

    var screenTitle: UIFont {
        return .systemFont(ofSize: 18, weight: .medium)
    }

    /// Мелкий шрифт, который используется почти на всех экранах
    var common: UIFont {
        return .systemFont(ofSize: 12, weight: .regular)
    }

    /// Надписи на кнопках с рамкой
    var button: UIFont {
        return .systemFont(ofSize: 16, weight: .medium)
    }

    /// Заголовок группы итемов
    var groupTitle: UIFont {
        return .systemFont(ofSize: 16, weight: .medium)
    }

    /// Заголовок итема в группе
    var itemTitle: UIFont {
        return .systemFont(ofSize: 14, weight: .medium)
    }

    var boldTitle1: UIFont {
        return .systemFont(ofSize: 22, weight: .bold)
    }

    var boldTitle2: UIFont {
        return .systemFont(ofSize: 28, weight: .bold)
    }

    /// Табы в верхней части экрана
    var topTabbar: UIFont {
        return .systemFont(ofSize: 14, weight: .regular)
    }

    /// Ниже шрифты, названия которым тяжело придумать, так как используются
    /// они редко и не поддаются какой-то систематизации. Их необходимо
    /// использовать только если ни один из шрифтов выше не подошел по смыслу.
    var style1: UIFont {
        return .systemFont(ofSize: 14, weight: .regular)
    }

    var style2: UIFont {
        return .systemFont(ofSize: 16, weight: .regular)
    }

    var style3: UIFont {
        return .systemFont(ofSize: 18, weight: .regular)
    }

    var style4: UIFont {
        return .systemFont(ofSize: 12, weight: .light)
    }

    var style5: UIFont {
        return .systemFont(ofSize: 14, weight: .medium)
    }
}

extension FontsPalette: PaletteComponent {

    enum Key: String {
        case screenTitle
        case common
        case button
        case groupTitle
        case itemTitle
        case boldTitle1
        case boldTitle2
        case topTabbar
        case style1
        case style2
        case style3
        case style4
        case style5
    }

    // swiftlint:disable:next cyclomatic_complexity
    public func value(for key: Key) -> UIFont {
        switch key {
        case .screenTitle:
            return screenTitle
        case .common:
            return common
        case .button:
            return button
        case .groupTitle:
            return groupTitle
        case .itemTitle:
            return itemTitle
        case .boldTitle1:
            return boldTitle1
        case .boldTitle2:
            return boldTitle2
        case .topTabbar:
            return topTabbar
        case .style1:
            return style1
        case .style2:
            return style2
        case .style3:
            return style3
        case .style4:
            return style4
        case .style5:
            return style5
        }
    }
}
