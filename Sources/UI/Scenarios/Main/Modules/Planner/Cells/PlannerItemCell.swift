//
//  PlannerItemCell.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 26/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

final class PlannerItemCell: UITableViewCell {

    // MARK: - Types
    struct Model {
        let title: String
        let isCompleted: Bool
        let completedImage: UIImage?
        let notCompletedImage: UIImage?
    }

    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var stateImageView: UIImageView!

    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextField.delegate = self
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return titleTextField.becomeFirstResponder()
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        return titleTextField.resignFirstResponder()
    }

    // MARK: - Public
    var titleChanged: ((String) -> Void)?

    func setup(with model: Model) {
        titleLabel.attributedText = model.title.attributed(with: model.isCompleted ? .completed : .notCompleted)
        titleTextField.text = model.title
        stateImageView.image = model.isCompleted ? model.completedImage : model.notCompletedImage
    }
}

extension PlannerItemCell: UITextFieldDelegate {

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

        textField.text = titleLabel.text
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        setupEditing(false)

        if let newText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !newText.isEmpty, newText != titleLabel.text {
            titleChanged?(newText)
        }
    }

    private func setupEditing(_ editing: Bool) {
        titleLabel.isHidden = editing
        titleTextField.isHidden = !editing
    }
}

private extension TextAttributes {

    static let completed = TextAttributes()
        .font(Palette.fonts.style1)
        .textColor(Palette.colors.common)
        .strikethroughColor(Palette.colors.common)
        .strikethroughStyle(.single)

    static let notCompleted = TextAttributes()
        .font(Palette.fonts.style1)
        .textColor(Palette.colors.subtitle)
}
