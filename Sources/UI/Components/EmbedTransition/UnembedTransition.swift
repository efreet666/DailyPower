//
//  UnembedTransition.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 04.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit
import XCoordinator

extension Transition {

    static func unembed(_ embeddedPresentable: Presentable,
                        from container: Container,
                        animation: EmbedAnimation? = nil) -> Transition {

        return Transition(presentables: [embeddedPresentable], animationInUse: nil) { rootViewController, options, completion in
            rootViewController.unembed(
                embeddedPresentable.viewController,
                from: container,
                animation: animation,
                options: options,
                completion: completion
            )
        }
    }
}

private extension UIViewController {

    func unembed(_ embeddedViewController: UIViewController,
                 from container: Container,
                 animation: EmbedAnimation?,
                 options: TransitionOptions,
                 completion: PresentationHandler?) {

        embeddedViewController.willMove(toParent: nil)
        embeddedViewController.view.removeFromSuperview()

        let completion: PresentationHandler = {
            embeddedViewController.removeFromParent()
            completion?()
        }

        guard options.animated, let animation = animation else {
            completion()
            return
        }

        let transition = with(CATransition(animation)) {
            $0.completion = { _ in completion() }
        }

        container.view.layer.add(transition, forKey: kCATransition)
    }
}
