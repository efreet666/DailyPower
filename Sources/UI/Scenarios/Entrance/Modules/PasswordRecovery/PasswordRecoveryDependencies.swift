//
//  AuthorizationDependencies.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

protocol PasswordRecoveryAuthService {

    func resetPassword1(email: String) -> Completable
}
