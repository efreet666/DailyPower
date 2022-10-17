//
//  AVPlayerEngine.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import AVFoundation
import RxCocoa
import RxSwift
import UIKit

final class AVPlayerEngine {

    // MARK: - Dependencies
    lazy var playerView: AVPlayerEngineSurfaceView = deferred()
    lazy var player: AVPlayer = deferred()
    lazy var playerItemFactory: AVPlayerEngineItemFactory = deferred()
    lazy var playerItemPreloader: AVPlayerEngineItemPreloader = deferred()
    lazy var connectionChecker: AVPlayerEngineConnectionChecker = deferred()

    // MARK: - Deinit
    deinit {
        player.pause()
        player.replaceCurrentItem(with: nil)
    }

    // MARK: - Public

    // swiftlint:disable:next function_body_length
    func configure() {
        let data = openParametersRelay
            .flatMapLatest { [playerItemFactory, playerItemPreloader] parameters in
                return playerItemFactory.createPlayerItem(url: parameters.url)
                    .flatMap { item -> Single<AVPlayerItem> in
                        if let time = parameters.seekTime {
                            return playerItemPreloader.preloadPlayerItem(item, time: time)
                        } else {
                            return .just(item)
                        }
                    }
                    .map { ($0, parameters.initiallyPaused) }
                    .asObservable()
                    .materialize()
            }
            .share(replay: 1)

        let playerItem = player.rx.currentItem.share(replay: 1)

        let loadingError = data.compactMap { $0.error }

        let stalledError = playerItem
            .flatMapLatest { $0?.rx.playbackStalled ?? .empty() }
            .withLatestFrom(connectionChecker.isConnectionAvailable)
            .filter { !$0 }
            .map(to: PlayerEngineError(.noInternet) as Error)

        weak var weakPlayer = player

        let playerError = player.rx.status
            .filter { $0 == .failed }
            .map { _ -> Error in PlayerEngineError(.playerFailed, underlyingError: weakPlayer?.error) }

        let itemError = playerItem.flatMapLatest { item -> Observable<Error> in
            guard let item = item else {
                return .empty()
            }

            weak var weakItem = item

            return item.rx.status
                .filter { $0 == .failed }
                .map { _ -> Error in PlayerEngineError(.itemPlaybackFailed, underlyingError: weakItem?.error) }
        }

        Observable
            .merge(
                playerItem.flatMapLatest { item -> Observable<PlayerEngineState?> in
                    guard let item = item else {
                        return .empty()
                    }
                    return Observable.combineLatest(item.rx.isBuffering, item.rx.status) { isBuffering, status -> PlayerEngineState? in
                        if isBuffering {
                            return .loading
                        } else if status == .readyToPlay {
                            return .ready
                        } else {
                            return nil
                        }
                    }
                },
                openParametersRelay.map(to: .loading),
                Observable.merge(stalledError, playerError, itemError, loadingError).map { .failed(error: $0) }
            )
            .compactMap { $0 }
            .distinctUntilChanged()
            .bind(to: engineStateRelay)
            .disposed(by: disposeBag)

        data
            .compactMap { $0.element }
            .bind(to: Binder(self) { base, tuple in
                let (item, initiallyPaused) = tuple

                base.player.replaceCurrentItem(with: item)

                if !initiallyPaused {
                    base.play()
                }
            })
            .disposed(by: disposeBag)

        itemPositionObservable = player.rx.periodicTimeObserver
            .map { $0.isNumeric ? .seconds(max($0.seconds, 0)) : .unknown }
            .share(replay: 1)

        itemDurationObservable = playerItem
            .flatMapLatest { item -> Observable<PlayerTime> in
                guard let item = item else {
                    return .just(.seconds(0))
                }
                return Observable.combineLatest(item.rx.duration, item.rx.status)
                    .filter { $0.1 == .readyToPlay }
                    .map { $0.0.isIndefinite ? .unknown : .seconds(max($0.0.seconds, 0)) }
            }
            .share(replay: 1)

        engineStateObservable = engineStateRelay
            .share(replay: 1)

        playbackStateObservable = Observable
            .combineLatest(player.rx.isPlaying, isSeekingRelay) { playing, seeking -> PlayerPlaybackState in
                switch (playing, seeking) {
                case (_, true):
                    return .seeking
                case (true, _):
                    return .playing
                case (false, _):
                    return .paused
                }
            }
            .share(replay: 1)

        playbackFinishedObservable = playerItem
            .flatMapLatest { $0?.rx.didPlayToEndTime ?? .empty() }
            .share()

        urlObservable = player.rx.url
            .share(replay: 1)
    }

    // MARK: - Private
    private typealias OpenParameters = (url: URL, seekTime: TimeInterval?, initiallyPaused: Bool)

    private let disposeBag = DisposeBag()
    private let openParametersRelay = PublishRelay<OpenParameters>()
    private let isSeekingRelay = BehaviorRelay<Bool>(value: false)
    private let engineStateRelay = BehaviorRelay<PlayerEngineState>(value: .unknown)

    private lazy var itemPositionObservable: Observable<PlayerTime> = deferred()
    private lazy var itemDurationObservable: Observable<PlayerTime> = deferred()
    private lazy var engineStateObservable: Observable<PlayerEngineState> = deferred()
    private lazy var playbackStateObservable: Observable<PlayerPlaybackState> = deferred()
    private lazy var playbackFinishedObservable: Observable<Void> = deferred()
    private lazy var urlObservable: Observable<URL?> = deferred()
}

extension AVPlayerEngine: PlayerEngine, PlayerSurfaceViewProvider {

    var surfaceView: UIView {
        return playerView
    }

    var scaleMode: Binder<PlayerScaleMode> {
        return Binder(self) {
            $0.playerView.scaleMode = $1
        }
    }

    var itemPosition: Observable<PlayerTime> {
        return itemPositionObservable
    }

    var itemDuration: Observable<PlayerTime> {
        return itemDurationObservable
    }

    var engineState: Observable<PlayerEngineState> {
        return engineStateObservable
    }

    var playbackState: Observable<PlayerPlaybackState> {
        return playbackStateObservable
    }

    var url: Observable<URL?> {
        return urlObservable
    }

    var playbackFinished: Observable<Void> {
        return playbackFinishedObservable
    }

    func open(url: URL, at time: TimeInterval?, initiallyPaused: Bool) {
        player.pause()
        player.currentItem?.cancelPendingSeeks()
        player.replaceCurrentItem(with: nil)

        openParametersRelay.accept(OpenParameters(url: url, seekTime: time, initiallyPaused: initiallyPaused))
    }

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    func seek(to time: TimeInterval) {
        guard let item = player.currentItem, item.status == .readyToPlay, item.canSeek(to: time) else {
            return
        }

        item.cancelPendingSeeks()
        isSeekingRelay.accept(true)

        item.seek(to: time) { [weak self] in
            self?.isSeekingRelay.accept(false)
        }
    }
}
