//
//  EmbedAnimation.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 04.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

struct EmbedAnimation {

    let type: CATransitionType
    let subtype: CATransitionSubtype?
    let duration: TimeInterval
    let timingFunction: CAMediaTimingFunction

    init(type: CATransitionType,
         subtype: CATransitionSubtype? = nil,
         duration: TimeInterval = 0.5,
         timingFunction: CAMediaTimingFunction = .default) {

        self.type = type
        self.subtype = subtype
        self.duration = duration
        self.timingFunction = timingFunction
    }
}

extension CATransition {

    convenience init(_ animation: EmbedAnimation) {
        self.init()

        type = animation.type
        subtype = animation.subtype
        duration = animation.duration
        timingFunction = animation.timingFunction
    }
}
