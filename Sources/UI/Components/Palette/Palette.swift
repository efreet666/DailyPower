//
//  Palette.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 13.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

final class Palette {

    // MARK: - Dependencies
    lazy var colors: ColorsPalette = deferred()
    lazy var fonts: FontsPalette = deferred()
    lazy var dimensions: DimensionsPalette = deferred()
}

extension Palette {

    /// Хэлпер для глобального доступа к палитре.
    /// Он нужен нам, так как мы не можем корректно заинжектить зависимость во вьюшки, инициализируемые через storyboard/xib.
    /// Это исключение из общих правил и по возможности должен использоваться инжект зависимости, а не глобальный доступ.
    static let `default` = PaletteAssembly.instance().palette

    static var colors: ColorsPalette {
        return Palette.default.colors
    }

    static var dimensions: DimensionsPalette {
        return Palette.default.dimensions
    }

    static var fonts: FontsPalette {
        return Palette.default.fonts
    }
}
