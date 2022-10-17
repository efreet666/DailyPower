//
//  ObservableType+Errors.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 22.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift

extension ObservableType {

    /// Catches error and completes the sequence
    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return .empty()
        }
    }

    /// Asserts the observable sequence never emits error
    func catchErrorNever(file: StaticString = #file, line: UInt = #line) -> Observable<Element> {
        return catchError { error in
            assertionFailure("Unexpected error in observable sequence: \(error)", file: file, line: line)
            return .empty()
        }
    }
}

enum SharedSequenceErrorHandler {
    case never
}

extension ObservableType {

    func asDriver(onError errorHandler: SharedSequenceErrorHandler, file: StaticString = #file, line: UInt = #line) -> Driver<Element> {
        return asDriver { error in
            switch errorHandler {
            case .never:
                assertionFailure("Unexpected error in observable sequence: \(error)", file: file, line: line)
                return .empty()
            }
        }
    }

    func asSignal(onError errorHandler: SharedSequenceErrorHandler, file: StaticString = #file, line: UInt = #line) -> Signal<Element> {
        return asSignal { error in
            switch errorHandler {
            case .never:
                assertionFailure("Unexpected error in observable sequence: \(error)", file: file, line: line)
                return .empty()
            }
        }
    }

    func retry(using errorHandlerProvider: ErrorHandlerProvider) -> Observable<Element> {
        return retryWhen(errorHandlerProvider.errorHandler)
    }
}

extension PrimitiveSequence where Trait == CompletableTrait, Element == Never {

    func retry(using errorHandlerProvider: ErrorHandlerProvider) -> Completable {
        return retryWhen(errorHandlerProvider.errorHandler)
    }
}

extension PrimitiveSequence where Trait == MaybeTrait {

    func retry(using errorHandlerProvider: ErrorHandlerProvider) -> Maybe<Element> {
        return retryWhen(errorHandlerProvider.errorHandler)
    }
}

extension PrimitiveSequence where Trait == SingleTrait {

    func retry(using errorHandlerProvider: ErrorHandlerProvider) -> Single<Element> {
        return retryWhen(errorHandlerProvider.errorHandler)
    }
}
