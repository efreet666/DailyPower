//
//  PlannerAlerts.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 19/04/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct PlannerAlerts {

    var limitReachedAlertContent: AlertContent {
        return AlertContent(
            title: R.string.localizable.alert_title_message(),
            message: R.string.localizable.planner_screen_limit_reached_message(),
            buttons: [.okay]
        )
    }

    var deleteItemAlertContent: AlertContent {
        return AlertContent(
            title: R.string.localizable.alert_title_message(),
            message: R.string.localizable.planner_screen_delete_taskgroup_message(),
            buttons: [.yes, .nope]
        )
    }
}
