//
//  ImageDownsamplerAssembly.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 01.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import EasyDi
import Foundation

final class ImageDownsamplerAssembly: Assembly {

    // MARK: - Public
    func imageDownsampler(preferredPixelSize: CGSize, compressionQuality: CGFloat) -> ImageDownsampler {
        return define(scope: .prototype, init: ImageDownsampler(preferredPixelSize: preferredPixelSize, compressionQuality: compressionQuality))
    }
}
