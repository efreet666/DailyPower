//
//  PhotoPickerViewController.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import MobileCoreServices
import RxCocoa
import RxSwift
import UIKit

final class PhotoPickerViewController: UIImagePickerController, ModuleView {

    // MARK: - Initialization
    convenience init(source: PhotoSource) {
        self.init()

        let sourceType = source.asUIImagePickerControllerSourceType()

        self.sourceType = type(of: self).isSourceTypeAvailable(sourceType) ? sourceType : .photoLibrary
        self.mediaTypes = [kUTTypeImage as String]
        self.allowsEditing = false
        self.delegate = self
    }

    // MARK: - ModuleView
    var output: PhotoPickerViewModel.Input {
        return PhotoPickerViewModel.Input(
            didSelectPhotoData: photoDataRelay.asSignal(),
            didCancelSelection: cancelRelay.asSignal()
        )
    }

    func setupBindings(to viewModel: PhotoPickerViewModel) -> Disposable {
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

    private let photoDataRelay = PublishRelay<Data>()
    private let cancelRelay = PublishRelay<Void>()
}

extension PhotoPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if #available(iOS 11.0, *) {
            if let data = info[.imageURL].flatMap({ ($0 as? URL).flatMap { try? Data(contentsOf: $0) } }) {
                photoDataRelay.accept(data)
                return
            }
        }
        if let data = info[.originalImage].flatMap({ ($0 as? UIImage).flatMap { $0.jpegData(compressionQuality: 1) } }) {
            photoDataRelay.accept(data)
            return
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        cancelRelay.accept(())
    }
}

private extension PhotoSource {

    func asUIImagePickerControllerSourceType() -> UIImagePickerController.SourceType {
        switch self {
        case .camera:
            return .camera
        case .library:
            return .photoLibrary
        }
    }
}
