//
//  UISlider+Rx.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 15.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UISlider {

    var minimumValue: Binder<Float> {
        return Binder(base) { base, value in
            base.minimumValue = value
        }
    }

    var maximumValue: Binder<Float> {
        return Binder(base) { base, value in
            base.maximumValue = value
        }
    }
}
