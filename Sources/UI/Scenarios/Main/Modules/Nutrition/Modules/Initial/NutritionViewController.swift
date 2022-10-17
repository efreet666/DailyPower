//
//  NutritionViewController.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class NutritionViewController: UIViewController, ModuleView {

    // MARK: - Dependencies

    // MARK: - Outlets

    // MARK: - ModuleView
    var output: NutritionViewModel.Input {
        return NutritionViewModel.Input()
    }

    func setupBindings(to viewModel: NutritionViewModel) -> Disposable {
        return Disposables.create()
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private
    private func setupUI() {
        navigationItem.title = R.string.localizable.nutrition_screen_title()
    }
}
