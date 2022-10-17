//
//  RTFDocumentConverter.swift
//  DailyPower
//
//  Created by Artyom Malyugin on 28/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation
import RxSwift

struct RTFDocumentConverter: DocumentConverter {

    func convert(document: Document, options: DocumentConverterOptions) -> Single<NSAttributedString> {
        return Single
            .create { observer in
                do {
                    let attributedString = try NSMutableAttributedString(
                        url: document.url,
                        options: [.documentType: NSAttributedString.DocumentType.rtf],
                        documentAttributes: nil
                    )

                    let wholeStringRange = NSRange(0 ..< attributedString.length)

                    if options.contains(.useSystemFont) {
                        attributedString.enumerateAttribute(.font, in: wholeStringRange) { value, range, _ in
                            if let font = value as? UIFont {
                                attributedString.removeAttribute(.font, range: range)
                                attributedString.addAttribute(.font, value: font.similarSystemFont, range: range)
                            }
                        }
                    }

                    if options.contains(.removeBackgroundColor) {
                        attributedString.removeAttribute(.backgroundColor, range: wholeStringRange)
                    }

                    if options.contains(.removeForegroundColor) {
                        attributedString.removeAttribute(.foregroundColor, range: wholeStringRange)
                    }

                    observer(.success(attributedString))
                } catch {
                    observer(.error(error))
                }

                return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
