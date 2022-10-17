//
//  ViewControllerAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import RxCocoa
import RxSwift
import UIKit

class ViewControllerAssembly<View, ViewModel>: Assembly where View: UIViewController & ModuleView, View.ViewModel == ViewModel {

    typealias Injection = (ViewModel) -> Void

    func bindViewModel(to viewController: View, injection: Injection? = nil) {
        bindViewModel(viewModel(injection: injection), to: viewController)
    }

    private func viewModel(injection: Injection?) -> ViewModel {
        return define(key: "viewModel", scope: .prototype, init: ViewModel()) {
            injection?($0)
            return $0
        }
    }

    private func bindViewModel(_ viewModel: ViewModel, to viewController: View) {
        if viewController.isViewLoaded {
            viewController.bindViewModel(viewModel)
        } else {
            viewController.scheduleViewModelBinding(viewModel)
        }
    }
}

private extension ModuleView where Self: UIViewController {

    func scheduleViewModelBinding(_ viewModel: ViewModel) {
        _ = rx.viewDidLoad
            .take(1)
            .bind(to: Binder(self) { base, _ in
                base.bindViewModel(viewModel)
            })
    }
}
