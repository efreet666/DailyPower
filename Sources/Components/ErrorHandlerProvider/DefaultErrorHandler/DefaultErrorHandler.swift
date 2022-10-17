//
//  DefaultErrorHandler.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 22.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultErrorHandler {

    // MARK: - Dependencies
    lazy var alertPresenter: AlertPresenter = deferred()
    lazy var errorAlertContentFactory: ErrorAlertContentFactory = deferred()
    lazy var authService: DefaultErrorHandlerAuthService = deferred()

    // MARK: - Public
    var errorHandler: (Observable<Error>) -> Observable<Void> {
        return { errorObservable -> Observable<Void> in
            return errorObservable.enumerated().flatMap { index, error -> Observable<Void> in
                guard index < 5 else {
                    return self.commonHandler(for: error)
                }

                if let handler = self.silentHandler(for: error) {
                    return handler.catchError(self.commonHandler)
                }

                return self.commonHandler(for: error)
            }
        }
    }

    // MARK: - Private
    private func silentHandler(for error: Error) -> Observable<Void>? {
        if let error = error as? POSIXError, error.code == .ECONNABORTED {
            return .just(())
        }

        if let error = error as? NetworkError, case let .serverError(payload) = error.code, payload.code == .tokenExpired {
            return authService.refreshAccessToken().andThen(Observable.just(()))
        }

        return nil
    }

    private func commonHandler(for error: Error) -> Observable<Void> {
        let content = errorAlertContentFactory.alertContent(for: error)

        return alertPresenter.presentErrorAlert(content: content)
            .flatMap { action -> Single<Void> in
                switch action {
                case .retry:
                    return .just(())
                default:
                    throw error
                }
            }
            .asObservable()
    }
}

extension DefaultErrorHandler: ErrorHandlerProvider {
}
