//
//  UIFont+Extensions.swift
//  DailyPower
//
//  Created by Artyom Malyugin on 29/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

extension UIFont {

    var similarSystemFont: UIFont {
        let optionalWeight = (fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any])?[.weight] as? UIFont.Weight
        let weight = optionalWeight ?? .regular

        let optionalSize = fontDescriptor.object(forKey: .size) as? CGFloat
        let size = optionalSize ?? fontDescriptor.pointSize

        var symbolicTraits: UIFontDescriptor.SymbolicTraits = []

        if fontDescriptor.symbolicTraits.contains(.traitBold) {
            symbolicTraits.insert(.traitBold)
        }

        if fontDescriptor.symbolicTraits.contains(.traitItalic) {
            symbolicTraits.insert(.traitItalic)
        }

        let font = UIFont.systemFont(ofSize: size, weight: weight)

        guard let descriptor = font.fontDescriptor.withSymbolicTraits(symbolicTraits) else {
            return font
        }

        return UIFont(descriptor: descriptor, size: 0)
    }
}
