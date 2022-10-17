//
//  MotivationViewController.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 19.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

final class MotivationViewController: UIViewController, ModuleView {

    // MARK: - Dependencies
    lazy var playerEmbedder: PlayerEmbedder<PlayerEmbedderTargetDefaultIdentifier> = deferred()

    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet private weak var loadingView: LoadingView!

    // MARK: - ModuleView
    var output: MotivationViewModel.Input {
        return MotivationViewModel.Input(
            reloadMotivationGroup: loadingView.rx.retryTap.asSignal()
        )
    }

    func setupBindings(to viewModel: MotivationViewModel) -> Disposable {
        let motivationGroup = viewModel.motivationGroupState.compactMap { state -> MotivationGroupDTO? in
            guard case let .content(content) = state else {
                return nil
            }
            return content
        }

        return Disposables.create(
            motivationGroup
                .map {
                    let sectionHeader = SectionHeader(
                        videoURL: $0.videoURL,
                        videoThumbnailURL: $0.videoThumbnailURL,
                        description: $0.description,
                        isExpanded: false
                    )
                    return [Section(model: sectionHeader, items: $0.motivations)]
                }
                .drive(collectionView.rx.items(dataSource: dataSource)),
            viewModel.motivationGroupState
                .map { $0.asLoadingViewMode() }
                .drive(loadingView.rx.mode)
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
        navigationItem.title = R.string.localizable.motivation_screen_title()

        loadingView.loadingText = R.string.localizable.motivation_screen_loading()
        loadingView.errorText = R.string.localizable.motivation_screen_loading_error()
        loadingView.retryText = R.string.localizable.motivation_screen_retry_loading()

        collectionView.register(R.nib.motivationCell)
        collectionView.register(R.nib.motivationGroupHeaderView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)

        flowLayout.sectionInset = Constants.sectionInset
        flowLayout.minimumInteritemSpacing = Constants.interitemSpacing
        flowLayout.minimumLineSpacing = Constants.lineSpacing
    }

    private func setupInternalBindings() {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        typealias Event = PlayerEmbedder<PlayerEmbedderTargetDefaultIdentifier>.Event

        Observable<Event>
            .merge(
                collectionView.rx.willDisplaySupplementaryView.compactMap { view, kind, indexPath -> Event? in
                    guard kind == UICollectionView.elementKindSectionHeader, let header = view as? MotivationGroupHeaderView else {
                        return nil
                    }
                    return .willDisplayDynamicTarget(identifier: .sectionHeader(indexPath.section), containerView: header.playerContainerView)
                },
                collectionView.rx.didEndDisplayingSupplementaryView.compactMap { _, kind, indexPath -> Event? in
                    guard kind == UICollectionView.elementKindSectionHeader else {
                        return nil
                    }
                    return .didEndDisplayingDynamicTarget(identifier: .sectionHeader(indexPath.section))
                },
                collectionView.rx.willDisplayCell.compactMap { cell, indexPath -> Event? in
                    guard let cell = cell as? MotivationCell else {
                        return nil
                    }
                    return .willDisplayDynamicTarget(identifier: .cell(indexPath), containerView: cell.playerContainerView)
                },
                collectionView.rx.didEndDisplayingCell.map { _, indexPath -> Event in
                    return .didEndDisplayingDynamicTarget(identifier: .cell(indexPath))
                },
                rx.viewWillAppear.map(to: .ownerWillAppear),
                rx.viewDidDisappear.map(to: .ownerDidDisappear)
            )
            .bind(to: playerEmbedder.rxEventHandler)
            .disposed(by: disposeBag)
    }

    private typealias ConfigureCell = RxCollectionViewSectionedReloadDataSource<Section>.ConfigureCell

    private lazy var configureCell: ConfigureCell = { [disposeBag, playerEmbedder]
                                                      _, collectionView, indexPath, element in

        let model = MotivationCell.Model(title: element.name, videoThumbnailURL: element.videoThumbnailURL)
        let identifier = R.reuseIdentifier.motivationCell

        return with(collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)!) {
            $0.setup(with: model)

            if let url = element.videoURL {
                let cancel = Observable.merge($0.rx.prepareForReuse.asObservable(), $0.rx.deallocated)

                $0.rx.didTapPlay
                    .asObservable()
                    .takeUntil(cancel)
                    .bind(to: Binder($0) { cell, _ in
                        playerEmbedder.embedPlayer(in: .dynamic(.cell(indexPath)), containerView: cell.playerContainerView, videoURL: url)
                    })
                    .disposed(by: disposeBag)
            }
        }
    }

    private typealias ConfigureSupplementaryView = RxCollectionViewSectionedReloadDataSource<Section>.ConfigureSupplementaryView

    private lazy var configureSupplementaryView: ConfigureSupplementaryView = { [disposeBag, playerEmbedder]
                                                                                dataSource, collectionView, kind, indexPath in

        let model = dataSource[indexPath.section].model
        let identifier = R.reuseIdentifier.motivationGroupHeaderView

        return with(collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)!) {
            $0.setup(with: model)

            let cancel = Observable.merge($0.rx.prepareForReuse.asObservable(), $0.rx.deallocated)

            $0.rx.didExpand
                .asObservable()
                .takeUntil(cancel)
                .bind(to: Binder(collectionView) { collectionView, _ in
                    model.isExpanded = true

                    collectionView.performBatchUpdates({
                        let context = with(UICollectionViewFlowLayoutInvalidationContext()) {
                            $0.invalidateSupplementaryElements(ofKind: kind, at: [indexPath])
                        }
                        collectionView.collectionViewLayout.invalidateLayout(with: context)
                    })
                })
                .disposed(by: disposeBag)

            if let url = model.videoURL {
                $0.rx.didTapPlay
                    .asObservable()
                    .takeUntil(cancel)
                    .bind(to: Binder($0) { header, _ in
                        let containerView = header.playerContainerView
                        playerEmbedder.embedPlayer(in: .dynamic(.sectionHeader(indexPath.section)), containerView: containerView, videoURL: url)
                    })
                    .disposed(by: disposeBag)
            }
        }
    }

    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<Section>(
        configureCell: configureCell,
        configureSupplementaryView: configureSupplementaryView
    )

    private typealias SectionHeader = MotivationGroupHeaderView.Model
    private typealias Section = SectionModel<SectionHeader, MotivationDTO>

    private let disposeBag = DisposeBag()
}

extension MotivationViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {

        let model = dataSource[section].model
        return MotivationGroupHeaderView.size(with: model, width: collectionView.frame.width)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            assertionFailure("Wrong layout type supplied")
            return .zero
        }

        let cellWidth = collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        let element = dataSource[indexPath]
        let model = MotivationCell.Model(title: element.name, videoThumbnailURL: element.videoThumbnailURL)

        return MotivationCell.size(with: model, width: cellWidth)
    }
}

private extension MotivationViewModel.MotivationGroupState {

    func asLoadingViewMode() -> LoadingView.Mode {
        switch self {
        case .loading:
            return .loading
        case .content:
            return .loaded
        case .error:
            return .error
        }
    }
}

private enum Constants {

    static let interitemSpacing: CGFloat = 0
    static let lineSpacing: CGFloat = 12

    static let sectionInset = UIEdgeInsets(
        top: 16,
        left: Palette.dimensions.mainHorizontalInset,
        bottom: 16,
        right: Palette.dimensions.mainHorizontalInset
    )
}
