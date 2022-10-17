//
//  PhotoSourcePickerAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import XCoordinator

final class PhotoSourcePickerAssembly: ViewControllerAssembly<PhotoSourcePickerViewController, PhotoSourcePickerViewModel> {

    // MARK: - Public
    func viewController(router: AnyRouter<ProfileRoute>, photoDestination: PhotoDestination) -> PhotoSourcePickerViewController {
        return define(scope: .prototype, init: PhotoSourcePickerViewController.picker()) {
            self.bindViewModel(to: $0) {
                $0.router = router
                $0.destination = photoDestination
            }
            return $0
        }
    }

    // MARK: - Private
}
