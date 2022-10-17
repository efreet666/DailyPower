//
//  AVPlayerItemFactory.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import AVFoundation
import RxSwift

struct AVPlayerItemFactory {

    func createPlayerItem(url: URL) -> Single<AVPlayerItem> {
        return Single.create { observer -> Disposable in
            let asset = AVURLAsset(url: url)

            var shouldCancelLoading = true
            var loadingCancelled = false

            let keys = [
                #keyPath(AVURLAsset.duration),
                #keyPath(AVURLAsset.tracks),
                #keyPath(AVURLAsset.isPlayable)
            ]

            asset.loadValuesAsynchronously(forKeys: keys) {
                if loadingCancelled {
                    return
                }

                shouldCancelLoading = false

                var error: Error?

                keys.forEach {
                    var statusError: NSError?
                    let status = asset.statusOfValue(forKey: $0, error: &statusError)

                    switch status {
                    case .unknown, .loading, .cancelled:
                        error = PlayerEngineError(.unexpectedItemStatus)
                    case .loaded:
                        break
                    case .failed:
                        error = PlayerEngineError(.itemLoadingFailed, underlyingError: statusError)
                    @unknown default:
                        error = PlayerEngineError(.unexpectedItemStatus)
                    }
                }

                if let error = error {
                    observer(.error(error))
                } else {
                    observer(.success(AVPlayerItem(asset: asset)))
                }
            }

            return Disposables.create {
                if shouldCancelLoading {
                    loadingCancelled = true
                    asset.cancelLoading()
                }
            }
        }
    }
}
