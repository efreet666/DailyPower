//
//  ProfileDependenciesExtensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 04.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift

extension UserProfileService: ProfileUserProfileService {
}

extension ImageDownsampler: ProfileImageDownsampler {
}

struct ProfileDataConduitPhotosProvider: ProfilePhotosProvider {

    let conduit: ProfileDataConduit

    var photoBeforeData: Signal<Data> {
        return conduit.emitter(for: .before)
    }

    var photoAfterData: Signal<Data> {
        return conduit.emitter(for: .after)
    }
}
