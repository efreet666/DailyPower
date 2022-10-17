//
//  PhotoSourcePickerViewModel.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import XCoordinator

final class PhotoSourcePickerViewModel: ModuleViewModel {

    // MARK: - Dependencies
    lazy var router: AnyRouter<ProfileRoute> = deferred()
    lazy var destination: PhotoDestination = deferred()

    // MARK: - ModuleViewModel
    struct Input {
        let didTapLibrary: Signal<Void>
        let didTapCamera: Signal<Void>
    }

    func setup(with input: Input) -> Disposable {
        return Signal<ProfileRoute>
            .merge(
                input.didTapLibrary.map(to: .selectPhoto(destination, .library)),
                input.didTapCamera.map(to: .selectPhoto(destination, .camera))
            )
            .emit(to: Binder(self) {
                $0.router.trigger($1)
            })
    }

    // MARK: - Public

    // MARK: - Private
}
