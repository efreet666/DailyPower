//
//  BusyButton.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 13.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class BusyButton: UIButton {

    // MARK: - Public
    var isBusy: Bool = false {
        didSet (previous) {
            if isBusy != previous {
                updateBusy()
            }
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

    // MARK: - Overrides
    override var state: UIControl.State {
        if isBusy {
            return .busy
        }
        return super.state
    }

    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        if state != .busy {
            super.setImage(image, for: state)
        }
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        if state != .busy {
            super.setTitle(title, for: state)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let activityIndicator = activityIndicator {
            activityIndicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
            activityIndicator.layoutSubviews()
        }
    }

    // MARK: - Private
    private func initialize() {
        super.setTitle("", for: .busy)
        super.setImage(UIImage(), for: .busy)

        updateBusy()
    }

    private func updateBusy() {
        isUserInteractionEnabled = !isBusy

        guard isBusy else {
            activityIndicator?.removeFromSuperview()
            activityIndicator = nil
            return
        }

        guard activityIndicator == nil else {
            activityIndicator?.startAnimating()
            return
        }

        let indicator = with(UIActivityIndicatorView(style: .white)) {
            $0.color = tintColor
        }

        addSubview(indicator)
        indicator.startAnimating()

        activityIndicator = indicator

        setNeedsLayout()
    }

    private var activityIndicator: UIActivityIndicatorView?
}

extension Reactive where Base: BusyButton {

    var isBusy: Binder<Bool> {
        return Binder(base) { base, busy in
            base.isBusy = busy
        }
    }
}

extension UIControl.State {

    static let busy = UIControl.State(rawValue: 1 << 16)
}
