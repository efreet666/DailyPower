//
//  PhotoSourcePickerViewController.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class PhotoSourcePickerViewController: UIAlertController, ModuleView {

    // MARK: - ModuleView
    var output: PhotoSourcePickerViewModel.Input {
        return PhotoSourcePickerViewModel.Input(
            didTapLibrary: useLibraryRelay.asSignal(),
            didTapCamera: useCameraRelay.asSignal()
        )
    }

    func setupBindings(to viewModel: PhotoSourcePickerViewModel) -> Disposable {
        return Disposables.create()
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private
    private func setupUI() {
    }

    private let useLibraryRelay = PublishRelay<Void>()
    private let useCameraRelay = PublishRelay<Void>()
}

extension PhotoSourcePickerViewController {

    static func picker() -> PhotoSourcePickerViewController {
        let controller = PhotoSourcePickerViewController(title: nil, message: nil, preferredStyle: .actionSheet)

        controller.addAction(
            UIAlertAction(
                title: R.string.localizable.profile_screen_photo_source_library(),
                style: .default,
                handler: { [weak controller] _ in
                    controller?.useLibraryRelay.accept(())
                }
            )
        )
        controller.addAction(
            UIAlertAction(
                title: R.string.localizable.profile_screen_photo_source_camera(),
                style: .default,
                handler: { [weak controller] _ in
                    controller?.useCameraRelay.accept(())
                }
            )
        )
        controller.addAction(
            UIAlertAction(
                title: R.string.localizable.profile_screen_photo_source_cancel(),
                style: .cancel
            )
        )

        return controller
    }
}
