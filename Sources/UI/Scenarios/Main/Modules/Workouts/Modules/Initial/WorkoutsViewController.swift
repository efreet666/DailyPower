//
//  WorkoutsViewController.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class WorkoutsViewController: UIViewController, ModuleView {

    // MARK: - Dependencies

    // MARK: - Outlets

    // MARK: - ModuleView
    var output: WorkoutsViewModel.Input {
        return WorkoutsViewModel.Input()
    }

    func setupBindings(to viewModel: WorkoutsViewModel) -> Disposable {
        return Disposables.create()
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private
    private func setupUI() {
        navigationItem.title = R.string.localizable.workouts_screen_title()
    }
}
