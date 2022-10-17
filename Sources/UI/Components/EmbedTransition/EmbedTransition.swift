//
//  EmbedTransition.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 04.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit
import XCoordinator

extension Transition {

    static func embed(_ presentable: Presentable,
                      in container: Container,
                      animation: EmbedAnimation? = nil) -> Transition {

        return Transition(presentables: [presentable], animationInUse: nil) { rootViewController, options, completion in
            rootViewController.embed(
                presentable.viewController,
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

    func embed(_ viewController: UIViewController,
               in container: Container,
               animation: EmbedAnimation?,
               options: TransitionOptions,
               completion: PresentationHandler?) {

        container.viewController.addChild(viewController)
        container.view.embedSubview(viewController.view)

        let completion: PresentationHandler = {
            viewController.didMove(toParent: container.viewController)
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
