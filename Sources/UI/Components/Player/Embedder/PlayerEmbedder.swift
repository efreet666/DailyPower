//
//  PlayerEmbedder.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 17.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class PlayerEmbedder<TargetIdentifier: Equatable> {

    // MARK: - Dependencies
    lazy var playerView: PlayerView = deferred()
    lazy var playerWindow: UIWindow = deferred()

    // MARK: - Types
    typealias Target = PlayerEmbedderTarget<TargetIdentifier>
    typealias Event = PlayerEmbedderEvent<TargetIdentifier>

    // MARK: - Public
    func configure() {
        isExpanded = false

        playerView.rx.didFinishPlayback
            .emit(onNext: { [weak self] in
                self?.unembedPlayer()
            })
            .disposed(by: disposeBag)

        Signal
            .merge(
                playerView.rx.didTapExpand.map(to: true),
                playerView.rx.didTapCollapse.map(to: false)
            )
            .emit(onNext: { [weak self] in
                self?.makePlayerViewExpanded($0)
            })
            .disposed(by: disposeBag)
    }

    func embedPlayer(in target: Target, containerView: UIView, videoURL: URL) {
        currentTarget = target
        currentContainerView = containerView

        playerView.startPlayback(videoURL: videoURL)

        embedPlayerView()
    }

    func unembedPlayer() {
        currentTarget = nil
        currentContainerView = nil

        playerView.stopPlayback()

        unembedPlayerView()
    }

    func handleEvent(_ event: Event) {
        switch event {
        case .ownerWillAppear:
            break
        case .ownerDidDisappear:
            playerView.stopPlayback()
        case let .willDisplayDynamicTarget(identifier, containerView):
            if let currentTarget = currentTarget, case let .dynamic(currentIdentifier) = currentTarget, currentIdentifier == identifier {
                currentContainerView = containerView
                embedPlayerView()
            }
        case let .didEndDisplayingDynamicTarget(identifier):
            if let currentTarget = currentTarget, case let .dynamic(currentIdentifier) = currentTarget, currentIdentifier == identifier {
                unembedPlayerView()
            }
        }
    }

    var rxEventHandler: Binder<Event> {
        return Binder(self) { base, event in
            base.handleEvent(event)
        }
    }

    // MARK: - Private
    private var isExpanded: Bool = false {
        didSet {
            playerView.setExpanded(isExpanded)
        }
    }

    private func embedPlayerView() {
        if isExpanded {
            guard let containerView = playerWindow.rootViewController?.view else {
                return
            }

            containerView.addSubview(playerView)
            setPlayerViewGeometry(containerSize: containerView.bounds.size, expanded: true)

            playerWindow.backgroundColor = Constants.blackBackgroundColor
            playerWindow.makeKeyAndVisible()
        } else {
            guard let containerView = currentContainerView else {
                return
            }

            containerView.addSubview(playerView)
            setPlayerViewGeometry(containerSize: containerView.bounds.size, expanded: false)
        }
    }

    private func unembedPlayerView() {
        playerView.removeFromSuperview()

        if isExpanded {
            UIView.animate(
                withDuration: Constants.animationDuration,
                animations: {
                    self.playerWindow.backgroundColor = Constants.clearBackgroundColor
                },
                completion: { _ in
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: Constants.statusBarAnimationDuration) {
                            self.playerWindow.isHidden = true
                        }
                    }
                }
            )

            isExpanded = false
        }
    }

    private func makePlayerViewExpanded(_ expanded: Bool) {
        if expanded {
            guard let containerView = playerWindow.rootViewController?.view else {
                return
            }

            playerView.frame = playerView.convert(playerView.bounds, to: containerView)

            containerView.addSubview(playerView)

            UIView.animate(withDuration: Constants.animationDuration) {
                self.setPlayerViewGeometry(containerSize: containerView.bounds.size, expanded: true)

                self.playerView.setNeedsLayout()
                self.playerView.layoutIfNeeded()

                self.playerWindow.backgroundColor = Constants.blackBackgroundColor
                self.playerWindow.makeKeyAndVisible()
            }
        } else {
            guard let containerView = currentContainerView else {
                return
            }

            UIView.animate(
                withDuration: Constants.animationDuration,
                animations: {
                    self.playerView.transform = .identity
                    self.playerView.frame = containerView.convert(containerView.bounds, to: self.playerView.superview)

                    self.playerView.setNeedsLayout()
                    self.playerView.layoutIfNeeded()

                    self.playerWindow.backgroundColor = Constants.clearBackgroundColor
                },
                completion: { _ in
                    containerView.addSubview(self.playerView)
                    self.setPlayerViewGeometry(containerSize: containerView.bounds.size, expanded: false)

                    DispatchQueue.main.async {
                        UIView.animate(withDuration: Constants.statusBarAnimationDuration) {
                            self.playerWindow.isHidden = true
                        }
                    }
                }
            )
        }

        isExpanded = expanded
    }

    private func setPlayerViewGeometry(containerSize: CGSize, expanded: Bool) {
        let fixedSize = { (size: CGSize) -> CGSize in
            if Constants.validAspectRatios.contains(size.width / size.height) {
                return size
            } else {
                return CGSize(width: (size.height * Constants.aspectRatio).rounded(.up), height: size.height)
            }
        }

        let size: CGSize
        let transform: CGAffineTransform

        if expanded {
            size = fixedSize(CGSize(width: containerSize.height, height: containerSize.width))
            transform = CGAffineTransform(rotationAngle: .pi / 2)
        } else {
            size = fixedSize(containerSize)
            transform = .identity
        }

        playerView.transform = .identity
        playerView.frame = CGRect(origin: CGPoint(x: (containerSize.width - size.width) / 2, y: (containerSize.height - size.height) / 2), size: size)
        playerView.transform = transform
    }

    private var currentTarget: Target?
    private var currentContainerView: UIView?
    private let disposeBag = DisposeBag()
}

private enum Constants {

    static let clearBackgroundColor = UIColor(white: 0, alpha: 0)
    static let blackBackgroundColor = UIColor(white: 0, alpha: 1)

    static let animationDuration: TimeInterval = 0.5
    static let statusBarAnimationDuration: TimeInterval = 0.25

    static let validAspectRatios: ClosedRange<CGFloat> = 1.75...1.85
    static let aspectRatio: CGFloat = 16 / 9
}
