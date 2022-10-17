//
//  AVPlayerItem+Extensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.04.2019.
//  Copyright © 2019 mobile.SimbirSoft. All rights reserved.
//

import AVFoundation
import RxSwift

extension AVPlayerItem {

    func seek(to time: TimeInterval, completion: @escaping () -> Void) {
        let targetTime = CMTime(seconds: time, preferredTimescale: 600)

        if #available(iOS 11.0, *) {
            // В ios11 можно перематывать непривязанные к плееру итемы функцией, принимающей completionHandler,
            // поэтому используем ее без дополнительных условий
            seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero) { _ in
                completion()
            }
        } else {
            // В предыдущих осях непривязанные к плееру итемы перематываются deprecated в ios11 функцией без
            // completionHandler, иначе краш. Привязанность к плееру можем проверить по статусу, у непривязанных
            // он обычно .unknown
            switch status {
            case .failed:
                break
            case .readyToPlay:
                seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero) { _ in
                    completion()
                }
            case .unknown:
                seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero)
                completion()
            @unknown default:
                break
            }
        }
    }

    func canSeek(to time: TimeInterval) -> Bool {
        return !duration.isIndefinite && (0 ..< duration.seconds).contains(time)
    }
}

extension Reactive where Base: AVPlayerItem {

    var status: Observable<AVPlayerItem.Status> {
        return observe(AVPlayerItem.Status.self, #keyPath(AVPlayerItem.status)).compactMap { $0 }
    }

    var duration: Observable<CMTime> {
        // xCode 11.1 / Swift 5.1
        // Это какой-то треш, но KVO не выдает .initial значение, тогда как оно
        // точно есть (длительность мы предзагружаем в AVPlayerItemFactory). С
        // предыдущим икскодом были странности с ios10, сдесь же не работает ни
        // на одной версии ios. В качестве воркараунда стартуем последовательность
        // с явно полученным значением, а затем ловим только .new, которых вобщем
        // и не будет, так как все видосы с фиксированной длительностью.
        return observe(CMTime.self, #keyPath(AVPlayerItem.duration), options: [.new])
            .compactMap { $0 }
            .startWith(base.duration)
    }

    var didPlayToEndTime: Observable<Void> {
        return NotificationCenter.default.rx.notification(.AVPlayerItemDidPlayToEndTime, object: base).map(to: ())
    }

    var playbackStalled: Observable<Void> {
        return NotificationCenter.default.rx.notification(.AVPlayerItemPlaybackStalled, object: base).map(to: ())
    }

    var isBuffering: Observable<Bool> {
        let isPlaybackLikelyToKeepUp = observe(Bool.self, #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp)).compactMap { $0 }
        let isPlaybackBufferFull = observe(Bool.self, #keyPath(AVPlayerItem.isPlaybackBufferFull)).compactMap { $0 }

        return Observable
            .combineLatest(isPlaybackLikelyToKeepUp, isPlaybackBufferFull) { !$0 && !$1 }
            .distinctUntilChanged()
    }
}
