//
//  Coordinator+Mapper.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 11.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import XCoordinator

extension Coordinator {

    func mapper<R: Route>(_ transitionFactory: @escaping (R) -> TransitionType) -> AnyRouter<R> {
        let coordinator = RedirectionCoordinator(
            viewController: UnpresentableViewController(),
            superTransitionPerformer: self,
            prepareTransition: transitionFactory
        )
        return coordinator.anyRouter
    }
}

private class UnpresentableViewController: UIViewController {

    func presented(from presentable: Presentable?) {
        fatalError("This coordinator should not be presented.")
    }
}
