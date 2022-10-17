//
//  SubscriptionsSerialQueue.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 21.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

enum SubscriptionPriority {

    case veryLow
    case low
    case normal
    case high
    case veryHigh
}

final class SubscriptionsSerialQueue<T> {

    // MARK: - Public
    func add(_ observable: Observable<T>, priority: SubscriptionPriority = .normal) -> Observable<T> {
        return Observable.create { observer in
            let cancel = SingleAssignmentDisposable()

            let operation = BlockOperation {
                if cancel.isDisposed {
                    return
                }

                let dispatchSemaphore = DispatchSemaphore(value: 0)

                let localDisposable = observable
                    .do(onDispose: {
                        dispatchSemaphore.signal()
                    })
                    .subscribe(observer)

                cancel.setDisposable(localDisposable)
                dispatchSemaphore.wait()
            }

            operation.queuePriority = priority.operationPriority

            self.operationQueue.addOperation(operation)

            return cancel
        }
    }

    // MARK: - Private
    private let operationQueue = with(OperationQueue()) {
        $0.maxConcurrentOperationCount = 1
    }
}

private extension SubscriptionPriority {

    var operationPriority: Operation.QueuePriority {
        switch self {
        case .veryLow:
            return .veryLow
        case .low:
            return .low
        case .normal:
            return .normal
        case .high:
            return .high
        case .veryHigh:
            return .veryHigh
        }
    }
}
