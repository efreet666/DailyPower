//
//  UserProfileService.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 29.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation
import RxSwift

final class UserProfileService {

    // MARK: - Dependencies
    lazy var networkClient: UserProfileServiceNetworkClient = deferred()

    // MARK: - Public
    func obtainUserProfile() -> Single<UserProfileDTO> {
        let request = ObtainUserProfileNetworkRequest()
        return networkClient.performRequest(request).payload()
    }

    func uploadPhotoBefore(data: Data) -> Single<UserProfileDTO> {
        let request = UploadPhotoBeforeNetworkRequest(data: data)
        return networkClient.performRequest(request).payload()
    }

    func uploadPhotoAfter(data: Data) -> Single<UserProfileDTO> {
        let request = UploadPhotoAfterNetworkRequest(data: data)
        return networkClient.performRequest(request).payload()
    }

    // MARK: - Private
}
