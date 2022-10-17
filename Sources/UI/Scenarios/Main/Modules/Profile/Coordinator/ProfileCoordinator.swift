//
//  ProfileCoordinator.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 02.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit
import XCoordinator

enum ProfileRoute: Route {

    enum Parent: Route {
        case finish
    }

    case initial
    case settings
    case selectPhotoSource(PhotoDestination)
    case selectPhoto(PhotoDestination, PhotoSource)
    case dismissPhotoPicker
    case finish
}

final class ProfileCoordinator: NavigationCoordinator<ProfileRoute> {

    // MARK: - Dependencies
    lazy var parentRouter: AnyRouter<ProfileRoute.Parent> = deferred()
    lazy var rootViewControllerConfigurator: ProfileCoordinatorRootViewControllerConfigurator = deferred()
    lazy var dataConduit: ProfileDataConduit = deferred()

    // MARK: - Public
    init() {
        super.init(initialRoute: nil)
    }

    func configure() {
        rootViewControllerConfigurator.configure(navigationController: rootViewController)
        trigger(.initial, with: TransitionOptions(animated: false))
    }

    // MARK: - Overrides
    override func prepareTransition(for route: ProfileRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let module = profileAssembly.viewController(router: anyRouter, dataConduit: dataConduit)
            return .set([module])
        case .settings:
            return .none()
        case let .selectPhotoSource(destination):
            let module = photoSourcePickerAssembly.viewController(router: anyRouter, photoDestination: destination)
            return .present(module)
        case let .selectPhoto(destination, source):
            let sink = dataConduit.sink(for: destination)
            let module = photoPickerAssembly.viewController(router: anyRouter, source: source, photoDataSink: sink)
            return .present(module)
        case .dismissPhotoPicker:
            return .dismiss()
        case .finish:
            return .trigger(.finish, on: parentRouter)
        }
    }

    // MARK: - Private
    private lazy var profileAssembly = ProfileAssembly.instance()
    private lazy var photoPickerAssembly = PhotoPickerAssembly.instance()
    private lazy var photoSourcePickerAssembly = PhotoSourcePickerAssembly.instance()
}
