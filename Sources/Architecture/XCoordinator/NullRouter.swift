//
//  NullRouter.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 31.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import XCoordinator

struct NullRouter<RouteType: Route>: Router {

    func contextTrigger(_ route: RouteType, with options: TransitionOptions, completion: ContextPresentationHandler?) {
        fatalError("Null router doesn't support routing")
    }

    var viewController: UIViewController! {
        fatalError("Null router doesn't support routing")
    }
}
