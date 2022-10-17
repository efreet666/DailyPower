//
//  AppDelegateProxy.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

final class AppDelegateProxy: NSObject {

    // MARK: - Public
    init(_ delegates: [UIApplicationDelegate] = []) {
        self.delegates = delegates
    }

    func add(_ delegate: UIApplicationDelegate) {
        guard delegates.contains(where: { $0 === delegate }) == false else {
            assertionFailure("\(type(of: delegate)) instance was already added")
            return
        }
        delegates.append(delegate)
    }

    // MARK: - Private
    private var delegates: [UIApplicationDelegate]
}

extension AppDelegateProxy: UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return delegates
            .map { $0.application?(application, didFinishLaunchingWithOptions: options) ?? false }
            .contains(true)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        delegates.forEach {
            $0.applicationDidBecomeActive?(application)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        delegates.forEach {
            $0.applicationWillResignActive?(application)
        }
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return delegates.reduce([.all]) {
            let result = $1.application?(application, supportedInterfaceOrientationsFor: window) ?? []
            return result.isEmpty ? $0 : $0.intersection(result)
        }
    }
}
