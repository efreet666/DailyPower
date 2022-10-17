//
//  PlayerEmbedderEvent.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 17.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

enum PlayerEmbedderEvent<Identifier: Equatable> {

    case ownerWillAppear
    case ownerDidDisappear
    case willDisplayDynamicTarget(identifier: Identifier, containerView: UIView)
    case didEndDisplayingDynamicTarget(identifier: Identifier)
}
