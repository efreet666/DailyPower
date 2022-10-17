//
//  ProfileDataConduit.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift

final class ProfileDataConduit {

    // MARK: - Dependencies

    // MARK: - Public
    func emitter(for destination: PhotoDestination) -> Signal<Data> {
        switch destination {
        case .before:
            return photoBeforeData.asSignal()
        case .after:
            return photoAfterData.asSignal()
        }
    }

    func sink(for destination: PhotoDestination) -> Binder<Data> {
        switch destination {
        case .before:
            return Binder(self) { base, data in
                base.photoBeforeData.accept(data)
            }
        case .after:
            return Binder(self) { base, data in
                base.photoAfterData.accept(data)
            }
        }
    }

    // MARK: - Private
    private let photoBeforeData = PublishRelay<Data>()
    private let photoAfterData = PublishRelay<Data>()
}
