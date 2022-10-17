//
//  DocumentViewerViewController.swift
//  DailyPower
//
//  Created by Artyom Malyugin on 28/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class DocumentViewerViewController: UIViewController, ModuleView {

    // MARK: - Dependencies
    lazy var isStandalone: Bool = deferred()
    lazy var converter: DocumentConverter = deferred()

    // MARK: - Outlets
    @IBOutlet private weak var textView: UITextView!

    // MARK: - ModuleView
    var output: DocumentViewerViewModel.Input {
        return DocumentViewerViewModel.Input(
            didTapClose: closeBarButtonItem.rx.tap.asSignal()
        )
    }

    func setupBindings(to viewModel: DocumentViewerViewModel) -> Disposable {
        return Disposables.create(
            viewModel.currentDocument
                .flatMap { [converter] in
                    converter.convert(document: $0, options: [.useSystemFont, .removeBackgroundColor, .removeForegroundColor])
                        .map {
                            with(NSMutableAttributedString(attributedString: $0)) {
                                $0.addAttributes(TextAttributes.text.dictionary, range: NSRange(0 ..< $0.length))
                            }
                        }
                        .asDriver(onErrorJustReturn: NSAttributedString())
                }
                .drive(textView.rx.attributedText),
            viewModel.currentDocument
                .map { $0.title }
                .drive(navigationItem.rx.title)
        )
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private
    private func setupUI() {
        navigationItem.rightBarButtonItem = isStandalone ? closeBarButtonItem : nil
        textView.linkTextAttributes = TextAttributes.link.dictionary
    }

    private lazy var closeBarButtonItem = UIBarButtonItem(image: R.image.common.close(), style: .plain, target: nil, action: nil)
}

private extension TextAttributes {

    static let link = TextAttributes()
        .textColor(Palette.colors.main)

    static let text = TextAttributes()
        .textColor(Palette.colors.subtitle)
}
