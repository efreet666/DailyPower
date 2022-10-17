//
//  SettingsCleanerDependencies.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 23/07/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

protocol SettingsCleanerAppSettings: class {

    var settingsCleaned: Bool { get set }
    var token: Token? { get set }
}
