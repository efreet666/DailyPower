//
//  UIAppearanceConfigurator.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 13.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation
import UIKit

final class UIAppearanceConfigurator {

    // MARK: - Dependencies
    lazy var palette: Palette = deferred()

    // MARK: - Public
    func configureUIAppearance() {
        let backButtonImage = R.image.common.back()
        let clearResizableImage = UIImage.color(.clear, options: .resizable)

        with(UINavigationBar.appearance()) {
            $0.barStyle = .black
            $0.isTranslucent = false

            $0.tintColor = palette.colors.common

            $0.setBackgroundImage(UIImage.color(palette.colors.topBarBackground, options: .resizable), for: .any, barMetrics: .default)
            $0.shadowImage = clearResizableImage

            $0.titleTextAttributes = [
                .foregroundColor: palette.colors.bright,
                .font: palette.fonts.screenTitle
            ]

            $0.backIndicatorImage = backButtonImage
            $0.backIndicatorTransitionMaskImage = backButtonImage
        }

        with(UITabBar.appearance()) {
            $0.barStyle = .black
            $0.isTranslucent = false

            $0.tintColor = palette.colors.main
            $0.unselectedItemTintColor = palette.colors.common

            $0.backgroundImage = UIImage.color(palette.colors.bottomBarBackground, options: .resizable)
            $0.shadowImage = clearResizableImage
        }
    }
}
