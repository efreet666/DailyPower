//
//  MotivationsService.swift
//  DailyPower
//
//  Created by Artem Malyugin on 01/04/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation
import RxSwift

final class MotivationsService {

    // MARK: - Dependencies
    lazy var networkClient: MotivationsServiceNetworkClient = deferred()

    // MARK: - Public
    func obtainMotivationGroups() -> Single<[MotivationGroupDTO]> {
        let request = ObtainMotivationGroupsNetworkRequest()
        return networkClient.performRequest(request).payload()
    }

    // MARK: - Private
}
