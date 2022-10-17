//
//  UIAppearanceConfiguratorAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 13.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class UIAppearanceConfiguratorAssembly: Assembly {

    // MARK: - Public
    var configurator: UIAppearanceConfigurator {
        return define(scope: .lazySingleton, init: UIAppearanceConfigurator()) {
            $0.palette = self.paletteAssembly.palette
            return $0
        }
    }

    // MARK: - Private
    private lazy var paletteAssembly: PaletteAssembly = context.assembly()
}
