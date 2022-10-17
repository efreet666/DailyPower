//
//  ObservableType+AdditionalOperators.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

extension ObservableType {

    func map<R>(to value: R) -> Observable<R> {
        return map { _ in value }
    }

    func apply<T, R>(_ transform: (Observable<Element>) -> R) -> Observable<T> where R: ObservableConvertibleType, R.Element == T {
        return transform(asObservable()).asObservable()
    }
}
