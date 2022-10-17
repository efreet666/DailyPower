//
//  RegistrationViewController.swift
//  DailyPower
//
//  Created by Влад Бокин on 17.10.2022.
//  Copyright © 2022 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class RegistrationViewController: UIViewController, ModuleView {

    // MARK: - Dependencies

    // MARK: - Outlets
    @IBOutlet private weak var loginButton: BusyButton!
    @IBOutlet private weak var showRegistrationButton: UIButton!
    @IBOutlet private weak var showPasswordRecoveryButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var conditionsTextView: UITextView!
    @IBOutlet private weak var controlsContainerView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!

    // MARK: - ModuleView
    var output: RegistrationViewModel.Input {
        return RegistrationViewModel.Input(
            performLogin: loginButton.rx.tap.asSignal(),
            showRegistration: showRegistrationButton.rx.tap.asSignal(),
            showPasswordRecovery: showPasswordRecoveryButton.rx.tap.asSignal(),
            showUserAgreement: showUserAgreementRelay.asSignal(),
            showPrivacyPolicy: showPrivacyPolicyRelay.asSignal(),
            emailText: emailTextField.rx.text.orEmpty.asDriver(),
            passwordText: passwordTextField.rx.text.orEmpty.asDriver()
        )
    }

    func setupBindings(to viewModel: RegistrationViewModel) -> Disposable {
        return Disposables.create(
            viewModel.canPerformLogin.drive(loginButton.rx.isEnabled),
            viewModel.isBusy.drive(loginButton.rx.isBusy),
            viewModel.isBusy.drive(controlsContainerView.rx.isUserInteractionDisabled)
        )
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupInternalBindings()
    }

    // MARK: - Private
    private func setupUI() {
        setupTextFields()
        setupConditions()
        setupButtons()
        setupTitles()
    }

    private func setupTextFields() {
        emailTextField.rightView = UIImageView(image: R.image.entrance.mail())
        emailTextField.rightViewMode = .always
        emailTextField.attributedPlaceholder = R.string.localizable.auth_screen_email_placeholder().attributed(with: .placeholder)

        passwordTextField.rightView = UIImageView(image: R.image.entrance.lock())
        passwordTextField.rightViewMode = .always
        passwordTextField.attributedPlaceholder = R.string.localizable.auth_screen_password_placeholder().attributed(with: .placeholder)
    }

    private func setupConditions() {
        let text = R.string.localizable.auth_screen_conditions_full()
        let attributedText = NSMutableAttributedString(attributedString: text.attributed(with: .smallText))

        let pairs = [
            (URL.userAgreement, R.string.localizable.auth_screen_conditions_user_agreement()),
            (URL.privacyPolicy, R.string.localizable.auth_screen_conditions_privacy_policy())
        ]
        pairs.forEach {
            attributedText.addAttributes([.link: $0.0], range: (text as NSString).range(of: $0.1))
        }

        conditionsTextView.attributedText = attributedText
        conditionsTextView.linkTextAttributes = TextAttributes.link.dictionary
    }

    private func setupButtons() {
        loginButton.setTitleInstantly(R.string.localizable.auth_screen_login(), for: .normal)
        showPasswordRecoveryButton.setTitleInstantly(R.string.localizable.auth_screen_password_recovery(), for: .normal)

        let text = R.string.localizable.auth_screen_registration_full()
        let attributedText = NSMutableAttributedString(attributedString: text.attributed(with: .smallText))

        attributedText.addAttributes(
            TextAttributes.link.dictionary,
            range: (text as NSString).range(of: R.string.localizable.auth_screen_registration())
        )

        showRegistrationButton.setAttributedTitle(attributedText, for: .normal)
    }

    private func setupTitles() {
        titleLabel.attributedText = R.string.localizable.auth_screen_title().attributed(with: .title)
    }

    private func setupInternalBindings() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillChangeFrameNotification)
            .compactMap { [weak self] notification -> UIEdgeInsets? in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                    return nil
                }
                guard let scrollViewFrame = self.map({ $0.scrollView.convert($0.scrollView.bounds, to: nil) }) else {
                    return nil
                }
                return UIEdgeInsets(top: 0, left: 0, bottom: scrollViewFrame.intersection(keyboardFrame).height, right: 0)
            }
            .bind(to: scrollView.rx.contentInset)
            .disposed(by: disposeBag)
    }

    private let disposeBag = DisposeBag()
    private let showUserAgreementRelay = PublishRelay<Void>()
    private let showPrivacyPolicyRelay = PublishRelay<Void>()
}

extension RegistrationViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailTextField {
            passwordTextField.becomeFirstResponder()
            return false
        } else if textField === passwordTextField {
            passwordTextField.resignFirstResponder()
            return false
        }

        return true
    }
}

extension RegistrationViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if url == .userAgreement {
            showUserAgreementRelay.accept(())
        } else if url == .privacyPolicy {
            showPrivacyPolicyRelay.accept(())
        }

        return false
    }
}

private extension URL {

    static let userAgreement = URL(string: "internal://user.agreement")!
    static let privacyPolicy = URL(string: "internal://privacy.policy")!
}

private extension TextAttributes {

    static let title = TextAttributes()
        .font(Palette.fonts.boldTitle1)
        .textColor(Palette.colors.title)
        .letterSpacing(-0.5)

    static let placeholder = TextAttributes()
        .font(Palette.fonts.style2)
        .textColor(Palette.colors.common)

    static let smallText = TextAttributes()
        .font(Palette.fonts.common)
        .textColor(Palette.colors.common)
        .lineHeight(16)
        .textAlignment(.center)

    static let link = TextAttributes()
        .textColor(Palette.colors.subtitle)
}
