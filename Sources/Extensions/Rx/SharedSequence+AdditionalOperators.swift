//
//  SharedSequence+AdditionalOperators.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift

extension SharedSequence {

    func map<R>(to value: R) -> SharedSequence<SharingStrategy, R> {
        return map { _ in value }
    }

    func compactMap<T>(_ transform: @escaping (Element) -> T?) -> SharedSequence<SharingStrategy, T> {
        return asObservable().compactMap(transform).asSharedSequence(onErrorDriveWith: .empty())
    }
}
