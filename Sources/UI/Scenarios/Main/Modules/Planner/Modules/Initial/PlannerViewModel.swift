//
//  PlannerViewModel.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 04.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import XCoordinator

final class PlannerViewModel: ModuleViewModel {

    // MARK: - Dependencies
    lazy var router: AnyRouter<PlannerRoute> = deferred()
    lazy var tasksService: PlannerTasksService = deferred()
    lazy var errorHandlerProvider: ErrorHandlerProvider = deferred()
    lazy var alertPresenter: AlertPresenter = deferred()
    lazy var updateProvider: PlannerUpdateProvider = deferred()
    lazy var alerts: PlannerAlerts = deferred()

    // MARK: - ModuleViewModel
    struct Input {
        let createItem: Signal<String>
        let updateItem: Signal<(TaskGroupDTO, String)>
        let deleteItem: Signal<TaskGroupDTO>
        let showItem: Signal<TaskGroupDTO>
        let reloadData: Signal<Void>
    }

    func setup(with input: Input) -> Disposable {
        let disposable = CompositeDisposable()

        input.reloadData
            .emit(to: reloadDataRelay)
            .disposed(with: disposable)

        input.deleteItem
            .flatMap(confirmDeletion)
            .emit(to: deleteItemRelay)
            .disposed(with: disposable)

        input.createItem
            .emit(to: createItemRelay)
            .disposed(with: disposable)

        input.updateItem
            .emit(to: updateItemRelay)
            .disposed(with: disposable)

        input.showItem
            .map { PlannerRoute.taskGroupDetails($0) }
            .emit(to: Binder(self) {
                $0.router.trigger($1)
            })
            .disposed(with: disposable)

        return disposable
    }

    // MARK: - Public
    enum TaskGroupsState {
        case loading
        case content([TaskGroupDTO])
        case error
    }

    private(set) lazy var isLoading = activityTracker.asDriver()

    private(set) lazy var taskGroupsState = reloadDataRelay
        .startWith(())
        .flatMapLatest { [weak self] _ -> Observable<TaskGroupsState> in
            guard let this = self else {
                return .just(.error)
            }
            return Observable
                .merge(this.obtainTaskGroups, this.createTaskGroup, this.updateTaskGroup, this.deleteTaskGroup, this.reloadTaskGroups)
                .scan(.loading, accumulator: this.accumulator)
                .startWith(.loading)
                .do(onNext: { [weak this] in
                    if case let .content(taskGroups) = $0 {
                        this?.taskGroupsCountRelay.accept(taskGroups.count)
                    } else {
                        this?.taskGroupsCountRelay.accept(0)
                    }
                })
        }
        .asDriver(onError: .never)

    // MARK: - Private
    private let activityTracker = ActivityTracker()
    private let reloadDataRelay = PublishRelay<Void>()
    private let deleteItemRelay = PublishRelay<TaskGroupDTO>()
    private let createItemRelay = PublishRelay<String>()
    private let updateItemRelay = PublishRelay<(TaskGroupDTO, String)>()
    private let taskGroupsCountRelay = BehaviorRelay<Int>(value: 0)

    private lazy var accumulator: (TaskGroupsState, Change) throws -> TaskGroupsState = { previousState, change in
        switch (change, previousState) {
        case let (.set(state), _):
            return state
        case let (.append(item), .content(taskGroups)):
            return .content(taskGroups + [item])
        case let (.update(item), .content(taskGroups)):
            return .content(taskGroups.map { $0.id == item.id ? item : $0 })
        case let (.delete(item), .content(taskGroups)):
            return .content(taskGroups.filter { $0.id != item.id })
        default:
            return previousState
        }
    }

    private lazy var obtainTaskGroups: Observable<Change> = tasksService.obtainTaskGroups()
        .asObservable()
        .map { .set(.content($0)) }
        .retry(using: errorHandlerProvider)
        .catchErrorJustReturn(.set(.error))

    private lazy var createTaskGroup = createItemRelay
        .withLatestFrom(taskGroupsCountRelay) { ($0, $1) }
        .flatMap { [weak self] name, taskGroupsCount -> Observable<Change> in
            guard let this = self else {
                return .empty()
            }

            if taskGroupsCount == 100 {
                return this.alertPresenter
                    .presentStandardAlert(content: this.alerts.limitReachedAlertContent)
                    .asCompletable()
                    .andThen(Observable.empty())
            }

            return this.tasksService.createTaskGroup(name: name)
                .asObservable()
                .map { .append($0) }
                .retry(using: this.errorHandlerProvider)
                .catchErrorJustComplete()
                .trackActivity(this.activityTracker)
        }

    private lazy var updateTaskGroup = updateItemRelay.flatMap { [weak self] taskGroup, name -> Observable<Change> in
        guard let this = self else {
            return .empty()
        }
        return this.tasksService.updateTaskGroup(id: taskGroup.id, name: name)
            .asObservable()
            .map { .update($0) }
            .retry(using: this.errorHandlerProvider)
            .catchErrorJustComplete()
            .trackActivity(this.activityTracker)
    }

    private lazy var deleteTaskGroup = deleteItemRelay.flatMap { [weak self] taskGroup -> Observable<Change> in
        guard let this = self else {
            return .empty()
        }
        return this.tasksService.deleteTaskGroup(id: taskGroup.id)
            .andThen(.just(.delete(taskGroup)))
            .retry(using: this.errorHandlerProvider)
            .catchErrorJustComplete()
            .trackActivity(this.activityTracker)
    }

    private lazy var reloadTaskGroups: Observable<Change> = updateProvider.updateData
        .asObservable()
        .flatMapLatest { [weak self] _ -> Observable<Change> in
            guard let this = self else {
                return .empty()
            }
            return this.tasksService.obtainTaskGroups()
                .asObservable()
                .map { .set(.content($0)) }
                .retry(using: this.errorHandlerProvider)
                .catchErrorJustComplete()
                .trackActivity(this.activityTracker)
        }

    private lazy var confirmDeletion: (TaskGroupDTO) -> Signal<TaskGroupDTO> = { [weak self] taskGroup in
        guard let this = self else {
            return .empty()
        }
        return this.alertPresenter
            .presentStandardAlert(content: this.alerts.deleteItemAlertContent)
            .asObservable()
            .filter { $0 == .yes }
            .map(to: taskGroup)
            .asSignal(onError: .never)
    }

    private enum Change {
        case set(TaskGroupsState)
        case append(TaskGroupDTO)
        case update(TaskGroupDTO)
        case delete(TaskGroupDTO)
    }
}
