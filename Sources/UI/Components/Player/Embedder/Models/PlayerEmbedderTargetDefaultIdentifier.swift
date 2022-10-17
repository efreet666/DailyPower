//
//  PlayerEmbedderTargetDefaultIdentifier.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 17.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

enum PlayerEmbedderTargetDefaultIdentifier: Equatable {

    case cell(IndexPath)
    case sectionHeader(Int)
    case sectionFooter(Int)
}
