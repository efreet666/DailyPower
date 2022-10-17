//
//  ImageDownsampler.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import CoreGraphics
import Foundation
import ImageIO
import MobileCoreServices
import RxSwift

struct ImageDownsampler {

    // MARK: - Public
    let preferredPixelSize: CGSize
    let compressionQuality: CGFloat

    func downsampleImage(data: Data) -> Single<Data> {
        return Single
            .create { observer in
                let result: (Data) -> Disposable = {
                    observer(.success($0))
                    return Disposables.create()
                }

                let sourceOptions = [
                    kCGImageSourceShouldCache: false
                ] as CFDictionary

                guard
                    let source = CGImageSourceCreateWithData(data as CFData, sourceOptions),
                    let mutableData = CFDataCreateMutable(kCFAllocatorDefault, 0),
                    let destination = CGImageDestinationCreateWithData(mutableData, kUTTypeJPEG, 1, nil)
                else {
                    return result(data)
                }

                let tuple = (0 ..< CGImageSourceGetCount(source))
                    .map { index -> (Int, CGFloat) in
                        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [AnyHashable: Any] else {
                            return (index, 0)
                        }
                        let width = properties[kCGImagePropertyPixelWidth] as? CGFloat ?? 0
                        let height = properties[kCGImagePropertyPixelHeight] as? CGFloat ?? 0

                        return (index, max(width, height))
                    }
                    .max { $0.1 < $1.1 }

                guard let (sourceImageIndex, sourceImagePixelSize) = tuple else {
                    return result(data)
                }

                let preferredPixelSize = max(self.preferredPixelSize.width, self.preferredPixelSize.height)

                let destinationProperties: CFDictionary

                if preferredPixelSize < sourceImagePixelSize {
                    destinationProperties = [
                        kCGImageDestinationLossyCompressionQuality: self.compressionQuality,
                        kCGImageDestinationImageMaxPixelSize: preferredPixelSize
                    ] as CFDictionary
                } else {
                    destinationProperties = [
                        kCGImageDestinationLossyCompressionQuality: self.compressionQuality
                    ] as CFDictionary
                }

                CGImageDestinationAddImageFromSource(destination, source, sourceImageIndex, destinationProperties)

                guard CGImageDestinationFinalize(destination), CFDataGetLength(mutableData) < data.count else {
                    return result(data)
                }

                return result(mutableData as Data)
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
