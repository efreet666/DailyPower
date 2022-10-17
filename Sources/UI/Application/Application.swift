//
//  Application.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

class Application: UIApplication {

    // MARK: - Public
    override init() {
        super.init()

        cleaner.cleanSettingsIfNeeded()

        delegate = appDelegate
    }

    // MARK: - Private
    private lazy var appDelegate = appDelegateAssembly.appDelegate // swiftlint:disable:this weak_delegate
    private lazy var cleaner = settingsCleanerAssembly.cleaner

    private lazy var appDelegateAssembly = AppDelegateAssembly.instance()
    private lazy var settingsCleanerAssembly = SettingsCleanerAssembly.instance()
}
