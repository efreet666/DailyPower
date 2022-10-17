//
//  DataValidator+Rx.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 25.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

extension DataValidator {

    // swiftlint:disable:next identifier_name
    var rx: Reactive<Self> {
        return Reactive(self)
    }
}

extension Reactive where Base: DataValidator {

    func validate(data: Base.DataRepresentation) -> Completable {
        return Completable.create { [base] observer in
            if case let .error(error) = base.validate(data: data) {
                observer(.error(error))
            } else {
                observer(.completed)
            }
            return Disposables.create()
        }
    }
}
