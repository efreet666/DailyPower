//
//  UIButton+Extensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 29.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

extension UIButton {

    func setTitleInstantly(_ title: String?, for state: UIControl.State) {
        UIView.performWithoutAnimation {
            setTitle(title, for: state)
            layoutIfNeeded()
        }
    }

    func setImageInstantly(_ image: UIImage?, for state: UIControl.State) {
        UIView.performWithoutAnimation {
            setImage(image, for: state)
            layoutIfNeeded()
        }
    }
}
