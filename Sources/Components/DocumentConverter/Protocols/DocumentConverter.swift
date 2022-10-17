//
//  DocumentConverter.swift
//  DailyPower
//
//  Created by Artyom Malyugin on 28/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation
import RxSwift

protocol DocumentConverter {

    func convert(document: Document, options: DocumentConverterOptions) -> Single<NSAttributedString>
}
