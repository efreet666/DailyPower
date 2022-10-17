//
//  ProfileAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 04.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import XCoordinator

final class ProfileAssembly: ViewControllerAssembly<ProfileViewController, ProfileViewModel> {

    // MARK: - Public
    func viewController(router: AnyRouter<ProfileRoute>, dataConduit: ProfileDataConduit) -> ProfileViewController {
        return define(scope: .prototype, init: R.storyboard.profile.initial()!) {
            self.bindViewModel(to: $0) {
                $0.router = router
                $0.userProfileService = self.userProfileServiceAssembly.service
                $0.errorHandlerProvider = self.defaultErrorHandlerAssembly.defaultErrorHandler
                $0.photosProvider = self.photosProvider(with: dataConduit)
                $0.imageDownsampler = self.imageDownsampler
            }
            return $0
        }
    }

    // MARK: - Private
    private var imageDownsampler: ProfileImageDownsampler {
        return imageDownsamplerAssembly.imageDownsampler(
            preferredPixelSize: CGSize(width: 1536, height: 2048),
            compressionQuality: 0.9
        )
    }

    private func photosProvider(with conduit: ProfileDataConduit) -> ProfilePhotosProvider {
        return define(scope: .prototype, init: ProfileDataConduitPhotosProvider(conduit: conduit))
    }

    private lazy var userProfileServiceAssembly: UserProfileServiceAssembly = context.assembly()
    private lazy var defaultErrorHandlerAssembly: DefaultErrorHandlerAssembly = context.assembly()
    private lazy var imageDownsamplerAssembly: ImageDownsamplerAssembly = context.assembly()
}
