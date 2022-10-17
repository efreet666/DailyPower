//
//  ProfileViewModel.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 04.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import XCoordinator

final class ProfileViewModel: ModuleViewModel {

    // MARK: - Dependencies
    lazy var router: AnyRouter<ProfileRoute> = deferred()
    lazy var userProfileService: ProfileUserProfileService = deferred()
    lazy var errorHandlerProvider: ErrorHandlerProvider = deferred()
    lazy var photosProvider: ProfilePhotosProvider = deferred()
    lazy var imageDownsampler: ProfileImageDownsampler = deferred()

    // MARK: - ModuleViewModel
    struct Input {
        let showSettings: Signal<Void>
        let reloadUserProfile: Signal<Void>
        let selectPhotoBefore: Signal<Void>
        let selectPhotoAfter: Signal<Void>
    }

    func setup(with input: Input) -> Disposable {
        let disposable = CompositeDisposable()

        input.reloadUserProfile
            .emit(to: reloadUserProfileRelay)
            .disposed(with: disposable)

        Signal<ProfileRoute>
            .merge(
                input.showSettings.map(to: .settings),
                input.selectPhotoBefore.map(to: .selectPhotoSource(.before)),
                input.selectPhotoAfter.map(to: .selectPhotoSource(.after))
            )
            .emit(to: Binder(self) {
                $0.router.trigger($1)
            })
            .disposed(with: disposable)

        return disposable
    }

    // MARK: - Public
    enum UserProfileState {
        case loading
        case content(UserProfileDTO)
        case error
    }

    private(set) lazy var isUploadingPhotoBefore = photoBeforeUploadingTracker.asDriver()
    private(set) lazy var isUploadingPhotoAfter = photoAfterUploadingTracker.asDriver()

    private(set) lazy var userProfileState = reloadUserProfileRelay
        .startWith(())
        .flatMapLatest { [weak self] _ -> Observable<UserProfileState> in
            guard let this = self else {
                return .just(.error)
            }
            return this.obtainProfile.concat(Observable.merge(this.uploadPhotoBefore, this.uploadPhotoAfter))
        }
        .asDriver(onError: .never)

    // MARK: - Private
    private lazy var obtainProfile: Observable<UserProfileState> = userProfileService.obtainUserProfile()
        .asObservable()
        .map { .content($0) }
        .retry(using: errorHandlerProvider)
        .catchErrorJustReturn(.error)
        .startWith(.loading)

    private lazy var uploadPhotoBefore: Observable<UserProfileState> = photosProvider.photoBeforeData
        .asObservable()
        .flatMapFirst { [weak self] data -> Observable<UserProfileState> in
            guard let this = self else {
                return .empty()
            }
            return this.imageDownsampler.downsampleImage(data: data)
                .asObservable()
                .flatMap { [weak this] data -> Observable<UserProfileState> in
                    guard let this = this else {
                        return .empty()
                    }
                    return this.userProfileService.uploadPhotoBefore(data: data)
                        .asObservable()
                        .map { .content($0) }
                        .retry(using: this.errorHandlerProvider)
                        .catchErrorJustComplete()
                }
                .trackActivity(this.photoBeforeUploadingTracker)
        }

    private lazy var uploadPhotoAfter: Observable<UserProfileState> = photosProvider.photoAfterData
        .asObservable()
        .flatMapFirst { [weak self] data -> Observable<UserProfileState> in
            guard let this = self else {
                return .empty()
            }
            return this.imageDownsampler.downsampleImage(data: data)
                .asObservable()
                .flatMap { [weak this] data -> Observable<UserProfileState> in
                    guard let this = this else {
                        return .empty()
                    }
                    return this.userProfileService.uploadPhotoAfter(data: data)
                        .asObservable()
                        .map { .content($0) }
                        .retry(using: this.errorHandlerProvider)
                        .catchErrorJustComplete()
                }
                .trackActivity(this.photoAfterUploadingTracker)
        }

    private let reloadUserProfileRelay = PublishRelay<Void>()
    private let photoBeforeUploadingTracker = ActivityTracker()
    private let photoAfterUploadingTracker = ActivityTracker()
}
