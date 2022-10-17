//
//  LoadingView.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 30.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class LoadingView: UIView {

    // MARK: - Outlets
    @IBOutlet private var loadingTextLabel: UILabel!
    @IBOutlet private var errorTextLabel: UILabel!
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!

    @IBOutlet fileprivate var retryButton: UIButton!

    // MARK: - Public
    enum Mode {
        case loading
        case loaded
        case error
    }

    var mode: Mode = .loading {
        didSet (previous) {
            if mode != previous {
                updateMode(animated: true)
            }
        }
    }

    var loadingText: String? {
        didSet {
            loadingTextLabel.attributedText = loadingText?.attributed(with: .text)
        }
    }

    var errorText: String? {
        didSet {
            errorTextLabel.attributedText = errorText?.attributed(with: .text)
        }
    }

    var retryText: String? {
        didSet {
            retryButton.setTitleInstantly(retryText, for: .normal)
        }
    }

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    // MARK: - Private
    private func initialize() {
        guard let view = R.nib.loadingView(owner: self) else {
            fatalError("Unable to instantiate view from nib \(R.nib.loadingView)")
        }
        embedSubview(view)
        containerView = view

        loadingText = nil
        errorText = nil
        retryText = nil
        backgroundColor = nil

        updateMode(animated: false)
    }

    private func updateMode(animated: Bool) {
        // swiftlint:disable:next large_tuple
        func alphaValues(_ mode: Mode) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
            switch mode {
            case .loading:
                return (1, 0, 0, 1)
            case .loaded:
                return (0, 0, 0, 0)
            case .error:
                return (0, 1, 1, 1)
            }
        }

        let animations: () -> Void = {
            (self.loadingTextLabel.alpha, self.errorTextLabel.alpha, self.retryButton.alpha, self.containerView.alpha) = alphaValues(self.mode)

            switch self.mode {
            case .loading:
                if !self.activityIndicatorView.isAnimating {
                    self.activityIndicatorView.startAnimating()
                }
                self.isUserInteractionEnabled = true
            case .loaded:
                if self.activityIndicatorView.isAnimating {
                    self.activityIndicatorView.stopAnimating()
                }
                self.isUserInteractionEnabled = false
            case .error:
                if self.activityIndicatorView.isAnimating {
                    self.activityIndicatorView.stopAnimating()
                }
                self.isUserInteractionEnabled = true
            }
        }

        if animated {
            UIView.animate(withDuration: 0.25, animations: animations)
        } else {
            animations()
        }
    }

    private lazy var containerView: UIView = deferred()
}

private extension TextAttributes {

    static let text = TextAttributes()
        .font(Palette.fonts.common)
        .textColor(Palette.colors.common)
        .lineHeight(16)
        .textAlignment(.center)
}

extension Reactive where Base: LoadingView {

    var retryTap: ControlEvent<Void> {
        return base.retryButton.rx.tap
    }

    var mode: Binder<Base.Mode> {
        return Binder(base) { base, mode in
            base.mode = mode
        }
    }
}
