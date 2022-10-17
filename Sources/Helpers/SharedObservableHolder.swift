//
//  SharedObservableHolder.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 21.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

class SharedObservableHolder<T, K: Hashable> {

    // MARK: - Public
    func sharedObservable(forKey key: K, replayBufferSize: Int, observableFactory: @escaping () -> Observable<T>) -> Observable<T> {
        return Observable<T>.deferred { () -> Observable<T> in
            return self.lock.performLocked { () -> Observable<T> in
                if let observable = self.sharedObservables[key] {
                    return observable
                }

                let observable = observableFactory()
                    .do(onDispose: { [weak self] in
                        if let this = self {
                            this.lock.performLocked {
                                this.sharedObservables.removeValue(forKey: key)
                            }
                        }
                    })
                    .share(replay: replayBufferSize, scope: .whileConnected)

                self.sharedObservables[key] = observable

                return observable
            }
        }
    }

    func removeAll() -> Completable {
        return Completable.execute {
            self.lock.performLocked {
                self.sharedObservables.removeAll()
            }
        }
    }

    // MARK: - Private
    private var sharedObservables = [K: Observable<T>]()
    private let lock = NSRecursiveLock()
}

final class SharedSingleHolder<T, K: Hashable>: SharedObservableHolder<T, K> {

    // MARK: - Public
    func sharedSingle(forKey key: K, singleFactory: @escaping () -> Single<T>) -> Single<T> {
        return sharedObservable(forKey: key, replayBufferSize: 1, observableFactory: { singleFactory().asObservable() }).asSingle()
    }
}

final class SharedCompletableHolder<K: Hashable>: SharedObservableHolder<Never, K> {

    // MARK: - Public
    func sharedCompletable(forKey key: K, completableFactory: @escaping () -> Completable) -> Completable {
        return sharedObservable(forKey: key, replayBufferSize: 0, observableFactory: { completableFactory().asObservable() }).asCompletable()
    }
}
