//
//  PlayerViewModel.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 11.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift

final class PlayerViewModel: ModuleViewModel {

    // MARK: - Dependencies
    lazy var engine: PlayerEngine = deferred()
    lazy var interruptionEventsProvider: PlayerInterruptionEventsProvider = deferred()

    // MARK: - ModuleViewModel
    struct Input {
        let open: Signal<URL>
        let play: Signal<Void>
        let pause: Signal<Void>
        let seek: Signal<TimeInterval>
        let retry: Signal<Void>
        let touches: Signal<Touch>
    }

    func setup(with input: Input) -> Disposable {
        return Disposables.create(
            setupEngineActions(with: input),
            setupOverlaysVisibility(with: input)
        )
    }

    // MARK: - Public
    enum Touch {
        case trackingBegan
        case trackingEnded
        case detected
    }

    func configure() {
        setupInternalBindings()
    }

    private(set) lazy var isLoading = Observable
        .combineLatest(engine.engineState.map { [.unknown, .loading].contains($0) }, engine.playbackState.map { $0 == .seeking }) { $0 || $1 }
        .distinctUntilChanged()
        .asDriver(onError: .never)

    private(set) lazy var isPlaying = engine.playbackState
        .filter { [.playing, .paused].contains($0) }
        .map { $0 == .playing }
        .distinctUntilChanged()
        .asDriver(onError: .never)

    private(set) lazy var contentPosition = engine.itemPosition
        .compactMap { $0.value }
        .distinctUntilChanged()
        .asDriver(onError: .never)

    private(set) lazy var contentDuration = engine.itemDuration
        .compactMap { $0.value }
        .distinctUntilChanged()
        .asDriver(onError: .never)

    private(set) lazy var isFailed = engine.engineState
        .map { $0.isFailed }
        .distinctUntilChanged()
        .asDriver(onError: .never)

    private(set) lazy var isOverlaysVisible = isOverlaysVisibleRelay
        .asDriver()
        .distinctUntilChanged()

    private(set) lazy var didFinishPlayback = engine.playbackFinished
        .asSignal(onError: .never)

    // MARK: - Private
    private enum EngineAction {
        case open(URL, TimeInterval?)
        case play
        case pause
        case seek(TimeInterval)
    }

    private func setupOverlaysVisibility(with input: Input) -> Disposable {
        let showThenAutohide = input.touches.compactMap { touch -> Bool? in
            switch touch {
            case .trackingBegan:
                return false
            case .trackingEnded:
                return true
            case .detected:
                return nil
            }
        }

        let hide = Signal.merge(
            input.touches.filter({ $0 == .detected }).map(to: ()),
            showThenAutohide.debounce(.seconds(4)).filter({ $0 }).map(to: ())
        )

        return Signal
            .merge(
                showThenAutohide.map(to: true),
                hide.map(to: false)
            )
            .startWith(false)
            .emit(to: isOverlaysVisibleRelay)
    }

    private func setupEngineActions(with input: Input) -> Disposable {
        let engineURLWithPosition = Observable.combineLatest(
            engine.url.compactMap { $0 },
            engine.itemPosition.map { $0.value }
        )

        let retryData = input.open
            .asObservable()
            .flatMapLatest { requestedURL in engineURLWithPosition.filter({ $0.0 == requestedURL }).startWith((requestedURL, nil)) }
            .asDriver(onError: .never)

        return Signal<EngineAction>
            .merge(
                input.open.map { .open($0, nil) },
                input.play.map(to: .play),
                input.pause.map(to: .pause),
                input.seek.map { .seek($0) },
                input.retry.withLatestFrom(retryData).map { .open($0.0, $0.1) }
            )
            .emit(to: performEngineAction)
    }

    private var performEngineAction: Binder<EngineAction> {
        return Binder(self) {
            switch $1 {
            case let .open(url, time):
                $0.engine.open(url: url, at: time, initiallyPaused: false)
            case .play:
                $0.engine.play()
            case .pause:
                $0.engine.pause()
            case let .seek(time):
                $0.engine.seek(to: time)
            }
        }
    }

    private func setupInternalBindings() {
        let interruptions = interruptionEventsProvider.interruptionBegan
            .asSignal(onError: .never)
            .withLatestFrom(isPlaying)
            .flatMapFirst { [interruptionEventsProvider] isPlaying -> Signal<EngineAction> in
                guard isPlaying else {
                    return .empty()
                }
                return interruptionEventsProvider.interruptionEnded.take(1).map(to: .play).startWith(.pause).asSignal(onError: .never)
            }

        Signal<EngineAction>
            .merge(
                interruptions,
                didFinishPlayback.map(to: .seek(0))
            )
            .emit(to: performEngineAction)
            .disposed(by: disposeBag)
    }

    private let disposeBag = DisposeBag()
    private let isOverlaysVisibleRelay = BehaviorRelay<Bool>(value: false)
}
