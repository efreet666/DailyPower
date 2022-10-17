//
//  PlayerView.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 11.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit.UIGestureRecognizerSubclass

// ⚠️⚠️⚠️
// Не использовать autolayout, только autoresizing mask и ручной рассчет фреймов.
// Причина - к этой view может быть применен transform.
// При использовании autolayout + transform ios10 выполняет лейаут неадекватно.
// ⚠️⚠️⚠️
final class PlayerView: UIView, ModuleView {

    // MARK: - Dependencies
    lazy var playerSurfaceViewProvider: PlayerSurfaceViewProvider = deferred()

    // MARK: - Outlets
    @IBOutlet private weak var dimmerView: UIView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var pauseButton: UIButton!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var progressSlider: UISlider!

    @IBOutlet fileprivate weak var expandButton: UIButton!
    @IBOutlet fileprivate weak var collapseButton: UIButton!

    @IBOutlet private weak var throbberView: UIView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    @IBOutlet private weak var errorView: UIView!
    @IBOutlet private weak var errorTextLabel: UILabel!
    @IBOutlet private weak var retryButton: UIButton!

    // MARK: - ModuleView
    var output: PlayerViewModel.Input {
        let touches = Signal<PlayerViewModel.Touch>.merge(
            touchesRecognizer.touchesBeganRelay.asSignal().map(to: .trackingBegan),
            touchesRecognizer.touchesEndedRelay.asSignal().map(to: .trackingEnded),
            tapRecognizer.rx.event.asSignal().filter({ $0.state == .recognized }).map(to: .detected)
        )

        return PlayerViewModel.Input(
            open: startPlaybackRelay.asSignal(),
            play: playButton.rx.tap.asSignal(),
            pause: Signal.merge(stopPlaybackRelay.asSignal(), pauseButton.rx.tap.asSignal()),
            seek: progressSlider.rx.value.changed.asSignal().map(TimeInterval.init),
            retry: retryButton.rx.tap.asSignal(),
            touches: touches
        )
    }

    func setupBindings(to viewModel: PlayerViewModel) -> Disposable {
        let isTracking = progressSlider.rx.observe(Bool.self, #keyPath(UISlider.isTracking))
            .compactMap { $0 }
            .distinctUntilChanged()
            .flatMapLatest { isTracking -> Observable<Bool> in
                let result = Observable.just(isTracking)
                return isTracking ? result : result.delaySubscription(.milliseconds(250), scheduler: MainScheduler.instance)
            }
            .asDriver(onError: .never)

        let position = viewModel.contentPosition.map(Float.init)
        let duration = viewModel.contentDuration.map(Float.init)

        let updatesDisabled = Driver.combineLatest(viewModel.isLoading, isTracking) { $0 || $1 }

        let safePosition = Driver
            .combineLatest(updatesDisabled, viewModel.contentPosition) { $0 ? Float?.none : Float($1) }
            .compactMap { $0 }
            .distinctUntilChanged()

        return Disposables.create(
            viewModel.isOverlaysVisible
                .drive(isOverlaysVisible),
            Driver.combineLatest(viewModel.isLoading, viewModel.isPlaying) { $0 ? true : $1 }
                .drive(playButton.rx.isHidden),
            Driver.combineLatest(viewModel.isLoading, viewModel.isPlaying) { $0 ? false : $1 }
                .drive(pauseButton.rx.isVisible),
            viewModel.isLoading
                .drive(throbberView.rx.isVisible),
            viewModel.isLoading
                .drive(activityIndicatorView.rx.isAnimating),
            viewModel.isFailed
                .drive(errorView.rx.isVisible),
            Driver.combineLatest(position, duration) { $1 == 0 ? 0 : $0 / $1 }
                .drive(progressView.rx.progress),
            duration
                .drive(progressSlider.rx.maximumValue),
            safePosition
                .drive(progressSlider.rx.value),
            viewModel.didFinishPlayback
                .emit(to: didFinishPlaybackRelay)
        )
    }

    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }

    // MARK: - Public
    func startPlayback(videoURL: URL) {
        startPlaybackRelay.accept(videoURL)
    }

    func stopPlayback() {
        stopPlaybackRelay.accept(())
    }

    func setExpanded(_ expanded: Bool) {
        expandButton.isHidden = expanded
        collapseButton.isHidden = !expanded
    }

    func configure() {
        embedPlayerSurfaceView()
    }

    // MARK: - Private
    private func setupUI() {
        progressSlider.setThumbImage(R.image.player.thumb(), for: .normal)
        progressSlider.setMinimumTrackImage(R.image.player.progress(), for: .normal)
        progressSlider.setMaximumTrackImage(R.image.player.track(), for: .normal)

        progressView.progressImage = R.image.player.progress()
        progressView.trackImage = R.image.player.track()

        errorTextLabel.attributedText = R.string.localizable.player_error().attributed(with: .text)

        retryButton.setTitleInstantly(R.string.localizable.player_retry(), for: .normal)

        addGestureRecognizer(touchesRecognizer)

        dimmerView.addGestureRecognizer(tapRecognizer)
    }

    private func setupLayout() {
        let errorTextHeight: CGFloat

        if let text = errorTextLabel.attributedText {
            let size = CGSize(width: errorTextLabel.bounds.width, height: .greatestFiniteMagnitude)
            errorTextHeight = text.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).height.rounded(.up)
        } else {
            errorTextHeight = 0
        }

        errorTextLabel.frame = CGRect(
            x: errorTextLabel.frame.minX,
            y: (errorView.bounds.height - errorTextHeight - retryButton.frame.height) / 2,
            width: errorTextLabel.frame.width,
            height: errorTextHeight
        )
        retryButton.frame = CGRect(
            x: retryButton.frame.minX,
            y: errorTextLabel.frame.maxY,
            width: retryButton.frame.width,
            height: retryButton.frame.height
        )
    }

    private func embedPlayerSurfaceView() {
        let playerSurfaceView = playerSurfaceViewProvider.surfaceView

        playerSurfaceView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerSurfaceView.translatesAutoresizingMaskIntoConstraints = true
        playerSurfaceView.frame = bounds

        insertSubview(playerSurfaceView, at: 0)
    }

    private var isOverlaysVisible: Binder<Bool> {
        return Binder(self) { base, visible in
            base.progressView.isHidden = false
            base.progressSlider.isHidden = true

            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                options: [.beginFromCurrentState],
                animations: {
                    base.dimmerView.alpha = visible ? 1 : 0
                    base.playButton.alpha = visible ? 1 : 0
                    base.pauseButton.alpha = visible ? 1 : 0
                    base.expandButton.alpha = visible ? 1 : 0
                    base.collapseButton.alpha = visible ? 1 : 0

                    if visible {
                        base.progressView.bounds = CGRect(x: 0, y: 0, width: base.progressSlider.frame.width, height: base.progressView.bounds.height)
                        base.progressView.center = base.progressSlider.center
                    } else {
                        base.progressView.bounds = CGRect(x: 0, y: 0, width: base.bounds.width, height: base.progressView.bounds.height)
                        base.progressView.center = CGPoint(x: base.bounds.midX, y: base.bounds.maxY - base.progressView.bounds.midY)
                    }
                },
                completion: { _ in
                    base.progressView.isHidden = visible
                    base.progressSlider.isHidden = !visible
                }
            )
        }
    }

    private let touchesRecognizer = TouchesRecognizer()
    private let tapRecognizer = UITapGestureRecognizer()

    private let startPlaybackRelay = PublishRelay<URL>()
    private let stopPlaybackRelay = PublishRelay<Void>()

    fileprivate let didFinishPlaybackRelay = PublishRelay<Void>()
}

private extension TextAttributes {

    static let text = TextAttributes()
        .font(Palette.fonts.common)
        .textColor(Palette.colors.common)
        .lineHeight(16)
        .textAlignment(.center)
}

private class TouchesRecognizer: UIGestureRecognizer {

    let touchesBeganRelay = PublishRelay<Void>()
    let touchesEndedRelay = PublishRelay<Void>()

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)

        cancelsTouchesInView = false
        delaysTouchesBegan = false
        delaysTouchesEnded = false
    }

    override func ignore(_ touch: UITouch, for event: UIEvent) {
        // Overriding this prevents touchesMoved:withEvent: not being called after moving a certain threshold
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        touchesBeganRelay.accept(())
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        touchesBeganRelay.accept(())
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        touchesEndedRelay.accept(())
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        touchesEndedRelay.accept(())
    }
}

extension Reactive where Base: PlayerView {

    var didFinishPlayback: Signal<Void> {
        return base.didFinishPlaybackRelay.asSignal()
    }

    var didTapExpand: Signal<Void> {
        return base.expandButton.rx.tap.asSignal()
    }

    var didTapCollapse: Signal<Void> {
        return base.collapseButton.rx.tap.asSignal()
    }
}
