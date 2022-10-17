//
//  AVPlayer+Extensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.04.2019.
//  Copyright © 2019 mobile.SimbirSoft. All rights reserved.
//

import AVFoundation
import RxSwift

extension Reactive where Base: AVPlayer {

    var isPlaying: Observable<Bool> {
        return observe(AVPlayer.TimeControlStatus.self, #keyPath(AVPlayer.timeControlStatus))
            .compactMap { $0 }
            .map { $0 == .playing }
            .distinctUntilChanged()
    }

    var url: Observable<URL?> {
        return currentItem.map { ($0?.asset as? AVURLAsset)?.url }
    }

    var status: Observable<AVPlayer.Status> {
        return observe(AVPlayer.Status.self, #keyPath(AVPlayer.status)).compactMap { $0 }
    }

    var currentItem: Observable<AVPlayerItem?> {
        return observe(AVPlayerItem.self, #keyPath(AVPlayer.currentItem))
    }

    var periodicTimeObserver: Observable<CMTime> {
        return Observable.create { [weak base] observer in
            guard let base = base else {
                observer.onCompleted()
                return Disposables.create()
            }

            let interval = CMTime(seconds: 0.5, preferredTimescale: 600)

            let token = base.addPeriodicTimeObserver(forInterval: interval, queue: nil) {
                observer.onNext($0)
            }

            return Disposables.create { [weak base] in
                base?.removeTimeObserver(token)
            }
        }
    }
}
