//
//  ProfileViewController.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 04.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class ProfileViewController: UIViewController, ModuleView {

    // MARK: - Dependencies

    // MARK: - Outlets
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var photosLabel: UILabel!
    @IBOutlet private weak var beforePhotoView: ProfilePhotoView!
    @IBOutlet private weak var afterPhotoView: ProfilePhotoView!
    @IBOutlet private weak var loadingView: LoadingView!
    @IBOutlet private weak var settingsBarButtonItem: UIBarButtonItem!

    // MARK: - ModuleView
    var output: ProfileViewModel.Input {
        return ProfileViewModel.Input(
            showSettings: settingsBarButtonItem.rx.tap.asSignal(),
            reloadUserProfile: loadingView.rx.retryTap.asSignal(),
            selectPhotoBefore: beforePhotoView.rx.tap.asSignal(),
            selectPhotoAfter: afterPhotoView.rx.tap.asSignal()
        )
    }

    func setupBindings(to viewModel: ProfileViewModel) -> Disposable {
        let userProfile = viewModel.userProfileState.compactMap { state -> UserProfileDTO? in
            guard case let .content(content) = state else {
                return nil
            }
            return content
        }

        return Disposables.create(
            userProfile
                .map { $0.email }
                .drive(emailLabel.rx.text),
            userProfile
                .map { $0.images.beforeURL }
                .drive(beforePhotoView.rx.imageURL),
            userProfile
                .map { $0.images.beforeURL != nil }
                .drive(beforePhotoView.rx.isSelected),
            Driver.combineLatest(viewModel.isUploadingPhotoBefore, beforePhotoView.rx.isLoadingImage) { $0 || $1 }
                .drive(beforePhotoView.rx.isBusy),
            userProfile
                .map { $0.images.afterURL }
                .drive(afterPhotoView.rx.imageURL),
            userProfile
                .map { $0.images.afterURL != nil }
                .drive(afterPhotoView.rx.isSelected),
            Driver.combineLatest(viewModel.isUploadingPhotoAfter, afterPhotoView.rx.isLoadingImage) { $0 || $1 }
                .drive(afterPhotoView.rx.isBusy),
            viewModel.userProfileState
                .map { $0.asLoadingViewMode() }
                .drive(loadingView.rx.mode)
        )
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private
    private func setupUI() {
        navigationItem.title = R.string.localizable.profile_screen_title()

        photosLabel.text = R.string.localizable.profile_screen_photos()

        loadingView.loadingText = R.string.localizable.profile_screen_loading()
        loadingView.errorText = R.string.localizable.profile_screen_loading_error()
        loadingView.retryText = R.string.localizable.profile_screen_retry_loading()
    }
}

private extension ProfileViewModel.UserProfileState {

    func asLoadingViewMode() -> LoadingView.Mode {
        switch self {
        case .loading:
            return .loading
        case .content:
            return .loaded
        case .error:
            return .error
        }
    }
}
