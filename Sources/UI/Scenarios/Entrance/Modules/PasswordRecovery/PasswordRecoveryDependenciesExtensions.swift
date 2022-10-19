//
//  AuthorizationDependenciesExtensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation
import RxSwift

extension AuthService: PasswordRecoveryAuthService {
    
    func resetPassword1(email: String) -> Completable {
        let request = ResetPasswordNetworkRequest(email: email)
        return networkClient.performRequest(request)
    }
    
}
