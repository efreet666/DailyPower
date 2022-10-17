//
//  UIView+Rx.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIView {

    var isVisible: Binder<Bool> {
        return Binder(base) { base, visible in
            base.isHidden = !visible
        }
    }

    var isUserInteractionDisabled: Binder<Bool> {
        return Binder(base) { base, disabled in
            base.isUserInteractionEnabled = !disabled
        }
    }
}
