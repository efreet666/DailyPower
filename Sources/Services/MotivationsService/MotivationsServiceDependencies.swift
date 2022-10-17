//
//  MotivationsServiceDependencies.swift
//  DailyPower
//
//  Created by Artem Malyugin on 01/04/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

protocol MotivationsServiceNetworkClient {

    func performRequest(_ request: ObtainMotivationGroupsNetworkRequest) -> Single<MotivationGroupsNetworkResponse>
}
