//
//  PlannerNewItemTextField.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 27/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class PlannerNewItemTextField: UITextField {

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    // MARK: - Overrides
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 32
        return rect
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 32
        return rect
    }

    // MARK: - Private
    private func initialize() {
        rightView = UIImageView(image: R.image.planner.plus())
        rightViewMode = .always
        leftView = UIView()
        leftViewMode = .always
        delegate = self
    }

    fileprivate let nameRelay = PublishRelay<String>()
}

extension Reactive where Base: PlannerNewItemTextField {

    var name: Signal<String> {
        return base.nameRelay.asSignal()
    }
}

extension PlannerNewItemTextField: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let resultText: String

        if let text = textField.text, let range = Range(range, in: text) {
            resultText = text.replacingCharacters(in: range, with: string)
        } else {
            resultText = string
        }

        return resultText.count <= 48
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        setupEditing(true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        setupEditing(false)

        guard let newText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }

        textField.text = nil

        if !newText.isEmpty {
            nameRelay.accept(newText)
        }
    }

    private func setupEditing(_ editing: Bool) {
        rightView?.isHidden = editing
        attributedPlaceholder = placeholder?.attributed(with: editing ? .inactivePlaceholder : .activePlaceholder)
    }
}

private extension TextAttributes {

    static let inactivePlaceholder = TextAttributes()
        .font(Palette.fonts.style1)
        .textColor(Palette.colors.common)

    static let activePlaceholder = TextAttributes()
        .font(Palette.fonts.style1)
        .textColor(Palette.colors.subtitle)
}
