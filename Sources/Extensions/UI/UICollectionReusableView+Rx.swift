//
//  UICollectionReusableView+Rx.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 08.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UICollectionReusableView {

    var prepareForReuse: ControlEvent<Void> {
        return ControlEvent(events: methodInvoked(#selector(UICollectionReusableView.prepareForReuse)).map(to: ()))
    }
}
