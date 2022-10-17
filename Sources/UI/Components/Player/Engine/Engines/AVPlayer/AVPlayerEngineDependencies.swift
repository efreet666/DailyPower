//
//  AVPlayerEngineDependencies.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import AVFoundation
import RxSwift

protocol AVPlayerEngineSurfaceViewRequirements: class {

    var scaleMode: PlayerScaleMode { get set }
    var player: AVPlayer? { get set }
}

typealias AVPlayerEngineSurfaceView = UIView & AVPlayerEngineSurfaceViewRequirements

protocol AVPlayerEngineItemFactory {

    /// Должен выдать в качестве значения AVPlayerItem с предзагруженными
    /// полями isPlayable, duration, tracks
    func createPlayerItem(url: URL) -> Single<AVPlayerItem>
}

protocol AVPlayerEngineItemPreloader {

    /// Должен выдать в качестве значения AVPlayerItem перемотанный на
    /// указанное время
    func preloadPlayerItem(_ item: AVPlayerItem, time: TimeInterval) -> Single<AVPlayerItem>
}

protocol AVPlayerEngineConnectionChecker {

    var isConnectionAvailable: Observable<Bool> { get }
}
