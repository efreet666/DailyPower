//
//  MotivationCell.swift
//  DailyPower
//
//  Created by Artem Malyugin on 02/04/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class MotivationCell: UICollectionViewCell {

    // MARK: - Types
    struct Model {
        let title: String
        let videoThumbnailURL: URL?
    }

    // MARK: - Outlets
    @IBOutlet fileprivate weak var videoView: VideoViewStyle2!

    // MARK: - Overrides
    override func prepareForReuse() {
        super.prepareForReuse()
        videoView.reset()
    }

    // MARK: - Public
    func setup(with model: Model) {
        videoView.setup(with: .init(title: model.title, thumbnailImage: .remote(model.videoThumbnailURL)))
    }

    var playerContainerView: UIView {
        return videoView
    }
}

extension Reactive where Base: MotivationCell {

    var didTapPlay: Signal<Void> {
        return base.videoView.rx.didTapPlay
    }
}

extension MotivationCell {

    static func size(with model: Model, width: CGFloat) -> CGSize {
        let sizingCellModel = Model(title: model.title, videoThumbnailURL: nil)

        sizingCell.setup(with: sizingCellModel)

        return sizingCell.contentView.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }

    private static let sizingCell = R.nib.motivationCell(owner: nil)!
}
