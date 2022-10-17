//
//  PhotoPickerAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import XCoordinator

final class PhotoPickerAssembly: ViewControllerAssembly<PhotoPickerViewController, PhotoPickerViewModel> {

    // MARK: - Public
    func viewController(router: AnyRouter<ProfileRoute>, source: PhotoSource, photoDataSink: Binder<Data>) -> PhotoPickerViewController {
        return define(scope: .prototype, init: PhotoPickerViewController(source: source)) {
            self.bindViewModel(to: $0) {
                $0.router = router
                $0.photoDataSink = photoDataSink
            }
            return $0
        }
    }

    // MARK: - Private
}
