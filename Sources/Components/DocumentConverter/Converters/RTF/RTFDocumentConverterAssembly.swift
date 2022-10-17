//
//  RTFDocumentConverterAssembly.swift
//  DailyPower
//
//  Created by Artyom Malyugin on 28/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class RTFDocumentConverterAssembly: Assembly {

    // MARK: - Public
    var converter: RTFDocumentConverter {
        return define(scope: .lazySingleton, init: RTFDocumentConverter())
    }
}
