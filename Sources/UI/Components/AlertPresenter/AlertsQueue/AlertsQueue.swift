//
//  AlertsQueue.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 22.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

final class AlertsQueue {

    // MARK: - Dependencies
    lazy var window: UIWindow = deferred()

    // MARK: - Public
    func presentAlert(content: AlertContent, presentationPriority: AlertPresentationPriority) -> Single<AlertContent.Button.Action> {
        return sharedSingles.sharedSingle(forKey: content) {
            let alert = self.createAlert(for: content)
                .asObservable()
                .retryWhen { errors -> Observable<Void> in
                    return errors.flatMap { error -> Observable<Void> in
                        guard (error as? Error) == .doublePresentation else {
                            throw error
                        }
                        return Observable.just(()).delaySubscription(.milliseconds(500), scheduler: MainScheduler.instance)
                    }
                }

            return self.subscriptionsSerialQueue.add(alert, priority: presentationPriority).asSingle()
        }
    }

    // MARK: - Private
    private func createAlert(for content: AlertContent) -> Single<AlertContent.Button.Action> {
        let worker = Single<AlertContent.Button.Action>.create { singleAction in
            guard let viewController = self.window.rootViewController else {
                singleAction(.error(UIError(.internalInconsistency)))
                return Disposables.create()
            }

            guard viewController.presentedViewController == nil else {
                singleAction(.error(Error.doublePresentation))
                return Disposables.create()
            }

            self.window.makeKeyAndVisible()

            let alertController = UIAlertController(title: content.title, message: content.message, preferredStyle: .alert)

            content.buttons.forEach { button in
                alertController.addAction(UIAlertAction(title: button.title, style: button.style.alertActionStyle) { _ in
                    singleAction(.success(button.action))
                })
            }

            viewController.present(alertController, animated: true)

            return Disposables.create {
                let completion: () -> Void = {
                    self.window.isHidden = true
                }

                if viewController.presentedViewController == nil {
                    completion()
                } else {
                    viewController.dismiss(animated: true, completion: completion)
                }
            }
        }

        return worker.subscribeOn(MainScheduler.instance)
    }

    private enum Error: Swift.Error {
        case doublePresentation
    }

    private let subscriptionsSerialQueue = SubscriptionsSerialQueue<AlertContent.Button.Action>()
    private let sharedSingles = SharedSingleHolder<AlertContent.Button.Action, AlertContent>()
}

private extension AlertContent.Button.Style {

    var alertActionStyle: UIAlertAction.Style {
        switch self {
        case .standard:
            return .default
        case .cancel:
            return .cancel
        case .destructive:
            return .destructive
        }
    }
}

extension AlertsQueue: AlertPresenter {
}
