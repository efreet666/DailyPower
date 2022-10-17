//
//  PaletteAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 13.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class PaletteAssembly: Assembly {

    // MARK: - Public
    var palette: Palette {
        return define(scope: .lazySingleton, init: Palette()) {
            $0.colors = self.colors
            $0.fonts = self.fonts
            $0.dimensions = self.dimensions
            return $0
        }
    }

    // MARK: - Private
    private var colors: ColorsPalette {
        return define(scope: .lazySingleton, init: ColorsPalette())
    }

    private var fonts: FontsPalette {
        return define(scope: .lazySingleton, init: FontsPalette())
    }

    private var dimensions: DimensionsPalette {
        return define(scope: .lazySingleton, init: DimensionsPalette())
    }
}
