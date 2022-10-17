//
//  ProfilePhotoView.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 29.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class ProfilePhotoView: UIView {

    // MARK: - Public
    var isBusy: Bool = false {
        didSet (previous) {
            if isBusy != previous {
                updateBusy()
            }
        }
    }

    var isSelected: Bool = false {
        didSet (previous) {
            if isSelected != previous {
                updateSelected()
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

    // MARK: - Private
    private func initialize() {
        with(borderView) {
            $0.isUserInteractionEnabled = false
            $0.dashedBorderColor = Palette.colors.auxBackground2
            $0.dashedBorderWidth = Palette.dimensions.mainBorderWidth
            $0.dashedBorderCornerRadius = Palette.dimensions.mainCornerRadius
            $0.dashedBorderPattern = [4, 2]
        }

        let clearImage = UIImage.color(.clear, options: .default)

        with(button) {
            $0.tintColor = Palette.colors.subtitle
            $0.setImage(R.image.profile.plus(), for: .normal)
            $0.setImage(clearImage, for: .selected)
            $0.setImage(clearImage, for: [.selected, .highlighted])
        }

        with(dimmerView) {
            $0.isUserInteractionEnabled = false
            $0.backgroundColor = Palette.colors.dimmed
        }

        with(imageView) {
            $0.contentMode = .scaleAspectFill
        }

        [borderView, imageView, dimmerView, button].forEach {
            embedSubview($0)
        }

        cornerRadius = Palette.dimensions.mainCornerRadius
        clipsToBounds = true

        updateBusy()
        updateSelected()
    }

    private func updateBusy() {
        button.isBusy = isBusy
        dimmerView.isHidden = !isBusy
    }

    private func updateSelected() {
        button.isSelected = isSelected
        borderView.isHidden = isSelected
    }

    private let borderView = DashedBorderView()
    private let dimmerView = UIView()

    fileprivate let button = BusyButton()
    fileprivate let imageView = RemoteImageView()
}

extension Reactive where Base: ProfilePhotoView {

    var imageURL: Binder<URL?> {
        return base.imageView.rx.image(resize: .bounds, presentation: .fade)
    }

    var tap: ControlEvent<Void> {
        return base.button.rx.tap
    }

    var isBusy: Binder<Bool> {
        return Binder(base) { base, busy in
            base.isBusy = busy
        }
    }

    var isSelected: Binder<Bool> {
        return Binder(base) { base, selected in
            base.isSelected = selected
        }
    }

    var isLoadingImage: Driver<Bool> {
        return base.imageView.rx.isLoading
    }
}
