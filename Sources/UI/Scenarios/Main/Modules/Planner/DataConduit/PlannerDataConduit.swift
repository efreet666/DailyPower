//
//  PlannerDataConduit.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 18/04/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift

final class PlannerDataConduit {

    // MARK: - Public
    func emitter() -> Signal<Void> {
        return updateRelay.asSignal()
    }

    func sink() -> Binder<Void> {
        return Binder(self) { base, data in
            base.updateRelay.accept(data)
        }
    }

    // MARK: - Private
    private let updateRelay = PublishRelay<Void>()
}
