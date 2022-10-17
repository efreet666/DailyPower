//
//  ExpandableLabelView.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 02/04/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import QuartzCore
import RxCocoa
import RxSwift
import UIKit

final class ExpandableLabelView: UIView {

    // MARK: - Public
    var text: String? {
        didSet {
            textLabel.attributedText = text?.attributed(with: .text)
            needsExpanding = isTextTruncated
        }
    }

    var collapsedNumberOfLines: Int = 1 {
        didSet {
            assert(collapsedNumberOfLines > 0, "Collapsed number of lines should be greater than zero.")

            gradientViewHeightConstraint = textLabel.heightAnchor.constraint(
                equalTo: gradientView.heightAnchor,
                multiplier: CGFloat(collapsedNumberOfLines)
            )

            updateExpanded()
        }
    }

    var isExpanded: Bool = false {
        didSet (previous) {
            if isExpanded != previous {
                updateExpanded()
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
    override func layoutSubviews() {
        super.layoutSubviews()
        needsExpanding = isTextTruncated
    }

    // MARK: - Private
    private func initialize() {
        let title = R.string.localizable.more_string().attributed(with: .more)
        let titleSize = title.size()
        let gradientWidth = 30 as CGFloat
        let buttonSize = CGSize(width: ceil(titleSize.width + gradientWidth), height: ceil(titleSize.height * 3))

        with(gradientView) {
            $0.isUserInteractionEnabled = false
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.gradientLayer.colors = [Palette.colors.background.withAlphaComponent(0).cgColor, Palette.colors.background.cgColor]
            $0.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            $0.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            $0.gradientLayer.locations = [0, (gradientWidth * 0.75 / buttonSize.width) as NSNumber]
        }

        with(moreButton) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentHorizontalAlignment = .right
            $0.contentVerticalAlignment = .bottom
            $0.setAttributedTitle(title, for: .normal)
            $0.addTarget(self, action: #selector(handleMoreButtonTap), for: .touchUpInside)
        }

        embedSubview(textLabel)

        [gradientView, moreButton].forEach {
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            moreButton.widthAnchor.constraint(equalToConstant: buttonSize.width),
            moreButton.heightAnchor.constraint(equalToConstant: buttonSize.height),
            moreButton.lastBaselineAnchor.constraint(equalTo: textLabel.lastBaselineAnchor),
            moreButton.rightAnchor.constraint(equalTo: textLabel.rightAnchor),
            gradientView.leftAnchor.constraint(equalTo: moreButton.leftAnchor),
            gradientView.rightAnchor.constraint(equalTo: moreButton.rightAnchor),
            gradientView.bottomAnchor.constraint(equalTo: textLabel.bottomAnchor)
        ])

        text = nil
        collapsedNumberOfLines = 1
        backgroundColor = nil

        updateExpanded()
    }

    @objc
    private func handleMoreButtonTap() {
        isExpanded = true
        didExpandRelay.accept(())
    }

    private var needsExpanding: Bool = false {
        didSet (previous) {
            if needsExpanding != previous {
                updateExpanded()
            }
        }
    }

    private func updateExpanded() {
        let canBeExpanded = needsExpanding && !isExpanded

        moreButton.isHidden = !canBeExpanded
        gradientView.isHidden = !canBeExpanded
        textLabel.numberOfLines = isExpanded ? 0 : collapsedNumberOfLines
    }

    private var isTextTruncated: Bool {
        guard let text = textLabel.attributedText else {
            return false
        }

        let textRect = text.boundingRect(
            with: CGSize(width: textLabel.bounds.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            context: nil
        )

        return textRect.height > textLabel.bounds.height
    }

    private var gradientViewHeightConstraint: NSLayoutConstraint? {
        didSet (previous) {
            previous?.isActive = false
            gradientViewHeightConstraint?.isActive = true
        }
    }

    fileprivate let didExpandRelay = PublishRelay<Void>()

    private let textLabel = UILabel()
    private let moreButton = UIButton(type: .system)
    private let gradientView = GradientView()
}

extension Reactive where Base: ExpandableLabelView {

    var text: Binder<String?> {
        return Binder(base) { base, text in
            base.text = text
        }
    }

    var isExpanded: Binder<Bool> {
        return Binder(base) { base, expanded in
            base.isExpanded = expanded
        }
    }

    var didExpand: Signal<Void> {
        return base.didExpandRelay.asSignal()
    }
}

private extension TextAttributes {

    static let text = TextAttributes()
        .font(Palette.fonts.common)
        .textColor(Palette.colors.common)
        .lineHeight(16)

    static let more = TextAttributes()
        .font(Palette.fonts.common)
        .textColor(Palette.colors.subtitle)
}
