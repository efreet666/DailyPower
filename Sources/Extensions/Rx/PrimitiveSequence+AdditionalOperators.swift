//
//  PrimitiveSequence+AdditionalOperators.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

extension PrimitiveSequence where Trait == SingleTrait {

    static func combineLatest<T1, T2>(_ source1: Single<T1>,
                                      _ source2: Single<T2>,
                                      resultSelector: @escaping (T1, T2) throws -> Element) -> Single<Element> {

        return Observable.combineLatest(source1.asObservable(), source2.asObservable(), resultSelector: resultSelector).asSingle()
    }

    static func combineLatest<T1, T2>(_ source1: Single<T1>,
                                      _ source2: Single<T2>) -> Single<Element> where Element == (T1, T2) {

        return Observable.combineLatest(source1.asObservable(), source2.asObservable()).asSingle()
    }

    func trackActivity(_ activityTracker: ActivityTracker) -> Single<Element> {
        return asObservable().trackActivity(activityTracker).asSingle()
    }

    func compactMap<T>(_ transform: @escaping (Element) throws -> T?) -> Maybe<T> {
        return asObservable().compactMap(transform).asMaybe()
    }

    func map<R>(to value: R) -> Single<R> {
        return map { _ in value }
    }
}

extension PrimitiveSequence where Trait == CompletableTrait, Element == Swift.Never {

    static func execute(_ action: @escaping () throws -> Void) -> Completable {
        return create { observer in
            do {
                try action()
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }

    func catchErrorJustComplete() -> Completable {
        return catchError { _ in
            return .empty()
        }
    }

    func trackActivity(_ activityTracker: ActivityTracker) -> Completable {
        return asObservable().trackActivity(activityTracker).asCompletable()
    }
}

extension PrimitiveSequence where Trait == MaybeTrait {

    func catchErrorJustComplete() -> Maybe<Element> {
        return catchError { _ in
            return .empty()
        }
    }

    func trackActivity(_ activityTracker: ActivityTracker) -> Maybe<Element> {
        return asObservable().trackActivity(activityTracker).asMaybe()
    }

    func compactMap<T>(_ transform: @escaping (Element) throws -> T?) -> Maybe<T> {
        return asObservable().compactMap(transform).asMaybe()
    }

    func map<R>(to value: R) -> Maybe<R> {
        return map { _ in value }
    }
}
