//
//  PlayerAppDelegate.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 11.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import AVFoundation
import RxCocoa
import RxSwift
import UIKit

final class PlayerAppDelegate: NSObject {

    // MARK: - Dependencies
    lazy var playerWindow: UIWindow = deferred()

    // MARK: - Private
    private let interruptionBeganRelay = PublishRelay<Void>()
    private let interruptionEndedRelay = PublishRelay<Void>()
}

extension PlayerAppDelegate: UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        playerWindow.frame = UIScreen.main.bounds

        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)

        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return window === playerWindow ? [.portrait] : []
    }

    func applicationWillResignActive(_ application: UIApplication) {
        interruptionBeganRelay.accept(())
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        interruptionEndedRelay.accept(())
    }
}

extension PlayerAppDelegate {

    var interruptionBegan: Observable<Void> {
        return interruptionBeganRelay.asObservable()
    }

    var interruptionEnded: Observable<Void> {
        return interruptionEndedRelay.asObservable()
    }
}
