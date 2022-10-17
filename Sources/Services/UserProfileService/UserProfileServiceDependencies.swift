//
//  UserProfileServiceDependencies.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 29.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

protocol UserProfileServiceNetworkClient {

    func performRequest(_ request: ObtainUserProfileNetworkRequest) -> Single<UserProfileNetworkResponse>
    func performRequest(_ request: UploadPhotoBeforeNetworkRequest) -> Single<UserProfileNetworkResponse>
    func performRequest(_ request: UploadPhotoAfterNetworkRequest) -> Single<UserProfileNetworkResponse>
}
