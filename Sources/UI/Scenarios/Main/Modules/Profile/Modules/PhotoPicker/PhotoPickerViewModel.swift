//
//  PhotoPickerViewModel.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import XCoordinator

final class PhotoPickerViewModel: ModuleViewModel {

    // MARK: - Dependencies
    lazy var router: AnyRouter<ProfileRoute> = deferred()
    lazy var photoDataSink: Binder<Data> = deferred()

    // MARK: - ModuleViewModel
    struct Input {
        let didSelectPhotoData: Signal<Data>
        let didCancelSelection: Signal<Void>
    }

    func setup(with input: Input) -> Disposable {
        let disposable = CompositeDisposable()

        input.didSelectPhotoData
            .emit(to: photoDataSink)
            .disposed(with: disposable)

        Signal<ProfileRoute>
            .merge(
                input.didSelectPhotoData.map(to: .dismissPhotoPicker).delay(.milliseconds(250)),
                input.didCancelSelection.map(to: .dismissPhotoPicker)
            )
            .emit(to: Binder(self) {
                $0.router.trigger($1)
            })
            .disposed(with: disposable)

        return disposable
    }

    // MARK: - Public

    // MARK: - Private
}
