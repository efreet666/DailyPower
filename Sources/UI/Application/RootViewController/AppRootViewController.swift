//
//  AppRootViewController.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 12.08.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

final class AppRootViewController: UIViewController {

    // MARK: - Overrides
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    @available(iOS 11.0, *)
    override var prefersHomeIndicatorAutoHidden: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.colors.background
    }
}
