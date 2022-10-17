//
//  PlayerScaleMode.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

enum PlayerScaleMode {

    // растянуть с сохранением пропорций и вписать в доступную область
    case fit
    // растянуть с сохранением пропорций и заполнить доступную область
    case fill
    // растянуть без сохранения пропорций и заполнить доступную область
    case stretch
}
