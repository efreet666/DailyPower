//
//  DocumentConverterOptions.swift
//  DailyPower
//
//  Created by Artyom Malyugin on 29/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct DocumentConverterOptions: OptionSet {

    let rawValue: Int

    static let useSystemFont = DocumentConverterOptions(rawValue: 1 << 0)
    static let removeForegroundColor = DocumentConverterOptions(rawValue: 1 << 1)
    static let removeBackgroundColor = DocumentConverterOptions(rawValue: 1 << 2)
}
