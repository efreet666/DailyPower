//
//  ModuleView.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

protocol ModuleView: class {

    associatedtype ViewModel: ModuleViewModel

    var output: ViewModel.Input { get }

    var viewModel: ViewModel { get }

    func setupBindings(to viewModel: ViewModel) -> Disposable

    func bindViewModel(_ viewModel: ViewModel)

    func unbindViewModel()
}

extension ModuleView where Self: NSObjectProtocol {

    var viewModel: ViewModel {
        guard let viewModel = viewModelBox?.viewModel else {
            fatalError("ViewModel is not bound")
        }
        return viewModel
    }

    func bindViewModel(_ viewModel: ViewModel) {
        viewModelBox = with(ViewModelBox(viewModel)) {
            viewModel.setup(with: output).disposed(by: $0.disposeBag)
            setupBindings(to: viewModel).disposed(by: $0.disposeBag)
        }
    }

    func unbindViewModel() {
        viewModelBox = nil
    }
}

private extension ModuleView where Self: NSObjectProtocol {

    var viewModelBox: ViewModelBox<ViewModel>? {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectKey.viewModelBox) as? ViewModelBox<ViewModel>
        }
        set (box) {
            objc_setAssociatedObject(self, &AssociatedObjectKey.viewModelBox, box, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private enum AssociatedObjectKey {
    static var viewModelBox: Int32 = 0
}

private class ViewModelBox<ViewModel> {

    let viewModel: ViewModel
    let disposeBag = DisposeBag()

    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}
