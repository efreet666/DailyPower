//
//  ModuleViewModel.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

protocol ModuleViewModel: class {

    associatedtype Input

    init()

    func setup(with input: Input) -> Disposable
}
