//
//  AlertContent.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 21.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct AlertContent: Hashable {

    struct Button: Hashable {

        enum Action {

            case okay
            case yes
            case nope
            case cancel
            case retry
        }

        enum Style {

            case standard
            case cancel
            case destructive
        }

        let title: String
        let style: Style
        let action: Action
    }

    let title: String?
    let message: String?
    let buttons: [Button]
}

extension AlertContent.Button {

    static let okay = AlertContent.Button(title: R.string.localizable.alert_button_ok(), style: .standard, action: .okay)
    static let yes = AlertContent.Button(title: R.string.localizable.alert_button_yes(), style: .standard, action: .yes)
    static let nope = AlertContent.Button(title: R.string.localizable.alert_button_nope(), style: .cancel, action: .nope)
    static let cancel = AlertContent.Button(title: R.string.localizable.alert_button_cancel(), style: .cancel, action: .cancel)
    static let retry = AlertContent.Button(title: R.string.localizable.alert_button_retry(), style: .standard, action: .retry)
}
