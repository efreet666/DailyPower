//
//  GradientView.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 17/04/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

final class GradientView: UIView {

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
}
