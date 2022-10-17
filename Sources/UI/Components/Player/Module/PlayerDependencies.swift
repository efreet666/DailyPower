//
//  PlayerDependencies.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 11.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

protocol PlayerInterruptionEventsProvider {

    var interruptionBegan: Observable<Void> { get }
    var interruptionEnded: Observable<Void> { get }
}
