//
//  CAAnimation+Extensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

extension CAAnimation {

    var start: (() -> Void)? {
        get {
            return (delegate as? AnimationDelegate)?.start
        }
        set (value) {
            if let animationDelegate = delegate as? AnimationDelegate {
                animationDelegate.start = value
            } else {
                delegate = with(AnimationDelegate()) {
                    $0.start = value
                }
            }
        }
    }

    var completion: ((Bool) -> Void)? {
        get {
            return (delegate as? AnimationDelegate)?.completion
        }
        set (value) {
            if let animationDelegate = delegate as? AnimationDelegate {
                animationDelegate.completion = value
            } else {
                delegate = with(AnimationDelegate()) {
                    $0.completion = value
                }
            }
        }
    }
}

private class AnimationDelegate: NSObject, CAAnimationDelegate {

    var start: (() -> Void)?
    var completion: ((Bool) -> Void)?

    func animationDidStart(_ animation: CAAnimation) {
        start?()
    }

    func animationDidStop(_ animation: CAAnimation, finished flag: Bool) {
        completion?(flag)
    }
}
