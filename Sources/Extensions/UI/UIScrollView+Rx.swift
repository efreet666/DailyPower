//
//  UIScrollView+Rx.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 21.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIScrollView {

    var contentInset: Binder<UIEdgeInsets> {
        return Binder(base) { base, inset in
            base.contentInset = inset
        }
    }
}
