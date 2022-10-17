//
//  MotivationGroupHeaderView.swift
//  DailyPower
//
//  Created by Artem Malyugin on 02/04/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class MotivationGroupHeaderView: UICollectionReusableView {

    // MARK: - Types
    final class Model {
        let videoURL: URL?
        let videoThumbnailURL: URL?
        let description: String
        var isExpanded: Bool

        init(videoURL: URL?, videoThumbnailURL: URL?, description: String, isExpanded: Bool = false) {
            self.videoURL = videoURL
            self.videoThumbnailURL = videoThumbnailURL
            self.description = description
            self.isExpanded = isExpanded
        }
    }

    // MARK: - Outlets
    @IBOutlet fileprivate weak var videoView: VideoViewStyle1!
    @IBOutlet fileprivate weak var descriptionView: ExpandableLabelView!

    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionView.collapsedNumberOfLines = 4
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        videoView.reset()
    }

    // MARK: - Public
    func setup(with model: Model) {
        videoView.setup(with: .init(thumbnailImage: .remote(model.videoThumbnailURL)))
        descriptionView.text = model.description
        descriptionView.isExpanded = model.isExpanded
    }

    var playerContainerView: UIView {
        return videoView
    }
}

extension Reactive where Base: MotivationGroupHeaderView {

    var didExpand: Signal<Void> {
        return base.descriptionView.rx.didExpand
    }

    var didTapPlay: Signal<Void> {
        return base.videoView.rx.didTapPlay
    }
}

extension MotivationGroupHeaderView {

    static func size(with model: Model, width: CGFloat) -> CGSize {
        let sizingViewModel = Model(videoURL: nil, videoThumbnailURL: nil, description: model.description, isExpanded: model.isExpanded)

        sizingView.setup(with: sizingViewModel)

        return sizingView.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }

    private static let sizingView = R.nib.motivationGroupHeaderView(owner: nil)!
}
