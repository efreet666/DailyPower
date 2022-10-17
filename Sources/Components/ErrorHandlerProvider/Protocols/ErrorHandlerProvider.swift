//
//  ErrorHandlerProvider.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 22.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation
import RxSwift

protocol ErrorHandlerProvider {

    var errorHandler: (Observable<Error>) -> Observable<Void> { get }
}
