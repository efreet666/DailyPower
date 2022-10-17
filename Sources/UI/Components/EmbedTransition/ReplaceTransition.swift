//
//  ReplaceTransition.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 04.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit
import XCoordinator

extension Transition {

    static func replace(_ embeddedPresentable: Presentable,
                        with presentable: Presentable,
                        in container: Container,
                        animation: EmbedAnimation? = nil) -> Transition {

        return Transition(presentables: [embeddedPresentable, presentable], animationInUse: nil) { rootViewController, options, completion in
            rootViewController.replace(
                embeddedPresentable.viewController,
                with: presentable.viewController,
                in: container,
                animation: animation,
                options: options,
                completion: {
                    presentable.presented(from: rootViewController)
                    completion?()
                }
            )
        }
    }
}

private extension UIViewController {

    // swiftlint:disable:next function_parameter_count
    func replace(_ embeddedViewController: UIViewController,
                 with viewController: UIViewController,
                 in container: Container,
                 animation: EmbedAnimation?,
                 options: TransitionOptions,
                 completion: PresentationHandler?) {

        container.viewController.addChild(viewController)
        embeddedViewController.willMove(toParent: nil)

        container.view.embedSubview(viewController.view)
        embeddedViewController.view.removeFromSuperview()

        let completion: PresentationHandler = {
            viewController.didMove(toParent: container.viewController)
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
