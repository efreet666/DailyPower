//
//  VideoViewStyle1.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 17.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class VideoViewStyle1: UIView {

    // MARK: - Types
    struct Model {

        enum Image {
            case remote(URL?)
            case local(UIImage?)
        }

        let thumbnailImage: Image
    }

    // MARK: - Outlets
    @IBOutlet fileprivate weak var imageView: RemoteImageView!
    @IBOutlet fileprivate weak var playButton: UIButton!

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    // MARK: - Public
    func setup(with model: Model) {
        switch model.thumbnailImage {
        case let .remote(url):
            imageView.setImage(url: url, resize: .bounds, presentation: .fade)
        case let .local(image):
            imageView.image = image
        }
    }

    func reset() {
        imageView.reset()
    }

    // MARK: - Private
    private func initialize() {
        guard let view = R.nib.videoViewStyle1(owner: self) else {
            fatalError("Unable to instantiate view from nib \(R.nib.videoViewStyle1)")
        }
        embedSubview(view)
        containerView = view
    }

    private lazy var containerView: UIView = deferred()
}

extension Reactive where Base: VideoViewStyle1 {

    var didTapPlay: Signal<Void> {
        return base.playButton.rx.tap.asSignal()
    }
}
