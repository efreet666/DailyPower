//
//  ProfileDependencies.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 04.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ProfileUserProfileService {

    func obtainUserProfile() -> Single<UserProfileDTO>
    func uploadPhotoBefore(data: Data) -> Single<UserProfileDTO>
    func uploadPhotoAfter(data: Data) -> Single<UserProfileDTO>
}

protocol ProfilePhotosProvider {

    var photoBeforeData: Signal<Data> { get }
    var photoAfterData: Signal<Data> { get }
}

protocol ProfileImageDownsampler {

    func downsampleImage(data: Data) -> Single<Data>
}
