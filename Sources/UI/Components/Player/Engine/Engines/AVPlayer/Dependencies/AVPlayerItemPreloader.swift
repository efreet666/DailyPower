//
//  AVPlayerItemPreloader.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import AVFoundation
import RxSwift

struct AVPlayerItemPreloader {

    func preloadPlayerItem(_ item: AVPlayerItem, time: TimeInterval) -> Single<AVPlayerItem> {
        return Single.create { observer -> Disposable in
            guard item.canSeek(to: time) else {
                observer(.success(item))
                return Disposables.create()
            }

            var shouldCancelSeek = true
            var seekCancelled = false

            item.seek(to: time) {
                if seekCancelled {
                    return
                }

                shouldCancelSeek = false

                observer(.success(item))
            }

            return Disposables.create {
                if shouldCancelSeek {
                    seekCancelled = true
                    item.cancelPendingSeeks()
                }
            }
        }
    }
}
