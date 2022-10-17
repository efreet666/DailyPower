//
//  AppSettings.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 05.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class AppSettings {

    // MARK: - Dependencies
    lazy var simpleStorage: AppSettingsStorage = deferred()
    lazy var secureStorage: AppSettingsStorage = deferred()

    // MARK: - Public
    var apiBaseURL: URL {
        get {
            return simpleStorage.get(Key.apiBaseURL).flatMap(URL.init(string:)) ?? Constants.defaultAPIBaseURL
        }
        set (value) {
            simpleStorage.set(value.absoluteString, forKey: Key.apiBaseURL)
            apiBaseURLRelay.accept(value)
        }
    }

    var apiBaseURLObservable: Observable<URL> {
        return apiBaseURLRelay.asObservable()
    }

    var token: Token? {
        get {
            return secureStorage.get(Key.token)
        }
        set (value) {
            if let value = value {
                secureStorage.set(value, forKey: Key.token)
            } else {
                secureStorage.delete(Key.token)
            }
            tokenRelay.accept(value)
        }
    }

    var tokenObservable: Observable<Token?> {
        return tokenRelay.asObservable()
    }

    var settingsCleaned: Bool {
        get {
            return simpleStorage.get(Key.settingsCleaned) ?? false
        }
        set (value) {
            simpleStorage.set(value, forKey: Key.settingsCleaned)
        }
    }

    // MARK: - Private
    private enum Key {
        static let apiBaseURL = "apiBaseURL"
        static let token = "token"
        static let settingsCleaned = "settingsCleaned"
    }

    private lazy var apiBaseURLRelay = BehaviorRelay(value: apiBaseURL)
    private lazy var tokenRelay = BehaviorRelay(value: token)

    private enum Constants {
        static let defaultAPIBaseURL = URL(string: "http://dev.dailypower.simbirsoft/api/")!
    }
}
