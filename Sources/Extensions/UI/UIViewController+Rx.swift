//
//  UIViewController+Rx.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIViewController {

    var viewDidLoad: ControlEvent<Void> {
        return ControlEvent(events: methodInvoked(#selector(UIViewController.viewDidLoad)).map(to: ()))
    }

    var viewWillAppear: ControlEvent<Void> {
        return ControlEvent(events: methodInvoked(#selector(UIViewController.viewWillAppear)).map(to: ()))
    }

    var viewDidAppear: ControlEvent<Void> {
        return ControlEvent(events: methodInvoked(#selector(UIViewController.viewDidAppear)).map(to: ()))
    }

    var viewWillDisappear: ControlEvent<Void> {
        return ControlEvent(events: methodInvoked(#selector(UIViewController.viewWillDisappear)).map(to: ()))
    }

    var viewDidDisappear: ControlEvent<Void> {
        return ControlEvent(events: methodInvoked(#selector(UIViewController.viewDidDisappear)).map(to: ()))
    }
}
