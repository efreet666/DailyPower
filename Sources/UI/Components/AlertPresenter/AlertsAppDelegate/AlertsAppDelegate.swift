//
//  AlertsAppDelegate.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 21.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

final class AlertsAppDelegate: NSObject {

    // MARK: - Dependencies
    lazy var alertsWindow: UIWindow = deferred()
}

extension AlertsAppDelegate: UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        alertsWindow.frame = UIScreen.main.bounds
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return window === alertsWindow ? [.portrait] : []
    }
}
