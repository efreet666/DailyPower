//
//  UserProfileServiceDependenciesExtensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 29.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

struct UserProfileServiceDefaultNetworkClient: UserProfileServiceNetworkClient {

    let performer: NetworkRequestPerformer

    func performRequest(_ request: ObtainUserProfileNetworkRequest) -> Single<UserProfileNetworkResponse> {
        return performer.performRequest(request)
    }

    func performRequest(_ request: UploadPhotoBeforeNetworkRequest) -> Single<UserProfileNetworkResponse> {
        return performer.performRequest(request)
    }

    func performRequest(_ request: UploadPhotoAfterNetworkRequest) -> Single<UserProfileNetworkResponse> {
        return performer.performRequest(request)
    }
}
