//
//  RemoteImageView.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 26.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Kingfisher
import RxCocoa
import RxSwift
import UIKit

final class RemoteImageView: UIImageView {

    // MARK: - Public
    enum ResizeMode {
        case bounds
        case original
    }

    enum PresentationMode {
        case instant
        case fade
    }

    @IBInspectable var placeholderImage: UIImage? = nil {
        didSet {
            if placeholderImageView == nil {
                let imageView = with(UIImageView(frame: bounds)) {
                    $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    $0.contentMode = placeholderContentMode
                }

                addSubview(imageView)

                Driver
                    .combineLatest(imageRelay.asDriver(), tracker.asDriver()) { $0 != nil || $1 }
                    .distinctUntilChanged()
                    .drive(imageView.rx.isHidden)
                    .disposed(by: disposeBag)

                placeholderImageView = imageView
            }
            placeholderImageView?.image = placeholderImage
        }
    }

    var placeholderContentMode: UIView.ContentMode = .center {
        didSet {
            placeholderImageView?.contentMode = contentMode
        }
    }

    func reset() {
        image = nil
    }

    func setImage(url: URL?, resize: ResizeMode, presentation: PresentationMode) {
        guard let url = url else {
            image = nil
            return
        }

        let key = (url as Resource).cacheKey
        let options = kingfisherOptions(resize: resize)

        if let cached = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: key, options: options) {
            image = cached
        } else {
            loadRelay.accept(.remote(RemoteImageParameters(url: url, resize: resize, presentation: presentation)))
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

    override init(image: UIImage?) {
        super.init(image: image)
        initialize()
    }

    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        initialize()
    }

    // MARK: - Overrides
    override var bounds: CGRect {
        didSet (previous) {
            if bounds.size != previous.size {
                boundsDidChangeRelay.accept(())
            }
        }
    }

    override var image: UIImage? {
        get {
            return presentedImage
        }
        set (value) {
            loadRelay.accept(.local(value))
        }
    }

    // MARK: - Private
    private func initialize() {
        presentedImage = image

        loadRelay
            .flatMapLatest { [weak self] image -> Observable<Image> in
                guard let this = self else {
                    return .empty()
                }

                switch image {
                case let .remote(parameters) where parameters.resize == .bounds:
                    return this.boundsDidChangeRelay.map(to: image).startWith(image)
                default:
                    return .just(image)
                }
            }
            .flatMapLatest { [weak self] image -> Observable<(UIImage?, PresentationMode)> in
                guard let this = self else {
                    return .empty()
                }

                switch image {
                case let .local(image):
                    return .just((image, .instant))
                case let .remote(parameters) where parameters.resize == .bounds:
                    // Используем async main scheduler на случай когда изменение bounds происходит сразу же вслед за запросом
                    // картинки, в этом случае подписка на скачивание картинки даже не успевает отработать (flatMapLatest).
                    // Например, такое может понадобиться когда размеры меняются из-за лейаута - загрузили ячейку из ксиба, в
                    // ячейке есть имиджвью, тут же ее просетапили урлом, но размер еще остается design-time, далее эта ячейка
                    // лейаутится и размер имиджвью меняется.
                    return this.download(parameters).subscribeOn(MainScheduler.asyncInstance).trackActivity(this.tracker)
                case let .remote(parameters):
                    return this.download(parameters).trackActivity(this.tracker)
                }
            }
            .bind(to: Binder(self) {
                $0.presentImage($1.0, mode: $1.1)
            })
            .disposed(by: disposeBag)
    }

    private var presentedImage: UIImage? {
        get {
            return super.image
        }
        set (value) {
            super.image = value
            imageRelay.accept(value)
        }
    }

    private func presentImage(_ image: UIImage?, mode: PresentationMode) {
        guard image !== presentedImage else {
            return
        }

        let animations: () -> Void = { self.presentedImage = image }

        switch mode {
        case .instant:
            animations()
        case .fade:
            UIView.transition(with: self, duration: 0.4, options: .transitionCrossDissolve, animations: animations)
        }
    }

    private func kingfisherOptions(resize: ResizeMode) -> KingfisherOptionsInfo {
        let common: KingfisherOptionsInfo = [.scaleFactor(UIScreen.main.scale), .backgroundDecode]

        switch resize {
        case .bounds:
            return common + [.processor(DownsamplingImageProcessor(size: bounds.size)), .cacheOriginalImage]
        case .original:
            return common
        }
    }

    private func download(_ parameters: RemoteImageParameters) -> Observable<(UIImage?, PresentationMode)> {
        return Observable
            .create { [weak self] observer in
                guard let this = self else {
                    observer.onCompleted()
                    return Disposables.create()
                }

                let options = this.kingfisherOptions(resize: parameters.resize)

                let task = KingfisherManager.shared.retrieveImage(with: parameters.url, options: options) {
                    switch $0 {
                    case let .success(item):
                        observer.onNext((item.image, item.cacheType == .memory ? .instant : parameters.presentation))
                        observer.onCompleted()
                    case let .failure(error) where error.isTaskCancelled == false:
                        observer.onNext((nil, .instant))
                        observer.onCompleted()
                    default:
                        break
                    }
                }

                return Disposables.create {
                    task?.cancel()
                }
            }
            .subscribeOn(MainScheduler.instance)
    }

    private enum Image {
        case local(UIImage?)
        case remote(RemoteImageParameters)
    }

    private struct RemoteImageParameters {
        let url: URL
        let resize: ResizeMode
        let presentation: PresentationMode
    }

    private let boundsDidChangeRelay = PublishRelay<Void>()
    private let loadRelay = PublishRelay<Image>()
    private let imageRelay = BehaviorRelay<UIImage?>(value: nil)
    private let disposeBag = DisposeBag()

    fileprivate let tracker = ActivityTracker()

    private var placeholderImageView: UIImageView?
}

extension Reactive where Base: RemoteImageView {

    func image(resize: RemoteImageView.ResizeMode, presentation: RemoteImageView.PresentationMode) -> Binder<URL?> {
        return Binder(base) { base, url in
            base.setImage(url: url, resize: resize, presentation: presentation)
        }
    }

    var isLoading: Driver<Bool> {
        return base.tracker.asDriver()
    }
}
