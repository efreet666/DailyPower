//
//  DashedBorderView.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 29.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

final class DashedBorderView: UIView {

    // MARK: - Public
    var dashedBorderWidth: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    var dashedBorderColor: UIColor = .clear {
        didSet {
            setNeedsDisplay()
        }
    }

    var dashedBorderPattern: [NSNumber]? = nil {
        didSet {
            setNeedsDisplay()
        }
    }

    var dashedBorderCornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
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
        updateLayout()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateContent()
    }

    // MARK: - Private
    private func initialize() {
        isOpaque = false
        clearsContextBeforeDrawing = true

        borderLayer.fillColor = nil

        layer.addSublayer(borderLayer)
    }

    private func updateLayout() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        let inset = dashedBorderWidth / 2

        borderLayer.frame = bounds
        borderLayer.lineWidth = dashedBorderWidth

        switch dashedBorderCornerRadius {
        case 0:
            borderLayer.path = UIBezierPath(rect: bounds.insetBy(dx: inset, dy: inset)).cgPath
        case let radius where radius > 0:
            borderLayer.path = UIBezierPath(roundedRect: bounds.insetBy(dx: inset, dy: inset), cornerRadius: radius).cgPath
        default:
            borderLayer.path = nil
        }

        CATransaction.commit()
    }

    private func updateContent() {
        borderLayer.strokeColor = dashedBorderColor.cgColor
        borderLayer.lineDashPattern = dashedBorderPattern
    }

    private let borderLayer = CAShapeLayer()
}
