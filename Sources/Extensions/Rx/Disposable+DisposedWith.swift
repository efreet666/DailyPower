//
//  Disposable+DisposedWith.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 04.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

extension Disposable {

    @discardableResult
    func disposed(with compositeDisposable: CompositeDisposable) -> CompositeDisposable.DisposeKey? {
        return compositeDisposable.insert(self)
    }
}
