//
//  UITableViewCell+Rx.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UITableViewCell {

    var prepareForReuse: ControlEvent<Void> {
        return ControlEvent(events: methodInvoked(#selector(UITableViewCell.prepareForReuse)).map(to: ()))
    }
}
