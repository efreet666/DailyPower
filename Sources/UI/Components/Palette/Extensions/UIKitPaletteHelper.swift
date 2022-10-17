//
//  UIKitPaletteHelper.swift
//  DailyPower
//
//  Created by Michael Krasnenkov on 14.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

enum UIKitPaletteHelper {

    static func get() -> String {
        assertionFailure("Invalid call to getter")
        return ""
    }

    static func set<Palette: PaletteComponent>(value keyString: String, from palette: Palette, setter: (Palette.Value) -> Void) {
        guard let key = Palette.Key(rawValue: keyString) else {
            assertionFailure("Palette '\(Palette.self)' has no key '\(keyString)'")
            return
        }
        setter(palette.value(for: key))
    }
}
