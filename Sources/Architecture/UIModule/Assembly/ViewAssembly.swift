//
//  ViewAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import UIKit

class ViewAssembly<View, ViewModel>: Assembly where View: UIView & ModuleView, View.ViewModel == ViewModel {

    typealias Injection = (ViewModel) -> Void

    func bindViewModel(to view: View, injection: Injection? = nil) {
        view.bindViewModel(viewModel(injection: injection))
    }

    private func viewModel(injection: Injection?) -> ViewModel {
        return define(key: "viewModel", scope: .prototype, init: ViewModel()) {
            injection?($0)
            return $0
        }
    }
}
