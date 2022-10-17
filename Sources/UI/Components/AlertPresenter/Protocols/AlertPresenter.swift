//
//  AlertPresenter.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 21.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation
import RxSwift

typealias AlertPresentationPriority = SubscriptionPriority

protocol AlertPresenter {

    func presentAlert(content: AlertContent, presentationPriority: AlertPresentationPriority) -> Single<AlertContent.Button.Action>
}

extension AlertPresenter {

    func presentStandardAlert(content: AlertContent) -> Single<AlertContent.Button.Action> {
        return presentAlert(content: content, presentationPriority: .normal)
    }

    func presentErrorAlert(content: AlertContent) -> Single<AlertContent.Button.Action> {
        return presentAlert(content: content, presentationPriority: .high)
    }
}
