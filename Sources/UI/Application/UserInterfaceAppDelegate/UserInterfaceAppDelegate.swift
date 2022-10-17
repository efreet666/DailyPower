//
//  UserInterfaceAppDelegate.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

final class UserInterfaceAppDelegate: NSObject {

    // MARK: - Dependencies
    lazy var appCoordinator: AppCoordinator = deferred()
    lazy var uiAppearanceConfigurator: UIAppearanceConfigurator = deferred()
    lazy var mainWindow: UIWindow = deferred()
}

extension UserInterfaceAppDelegate: UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        mainWindow.frame = UIScreen.main.bounds

        uiAppearanceConfigurator.configureUIAppearance()

        appCoordinator.setRoot(for: mainWindow)

        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return window === mainWindow ? [.portrait] : []
    }
}
