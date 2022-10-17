//
//  DefaultErrorHandlerDependencies.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 26.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

protocol DefaultErrorHandlerAuthService {

    func refreshAccessToken() -> Completable
}
