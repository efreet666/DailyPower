//
//  TaskGroupDetailsViewModel.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 29/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import XCoordinator

final class TaskGroupDetailsViewModel: ModuleViewModel {

    // MARK: - Dependencies
    lazy var router: AnyRouter<PlannerRoute> = deferred()
    lazy var tasksService: TaskGroupDetailsTasksService = deferred()
    lazy var errorHandlerProvider: ErrorHandlerProvider = deferred()
    lazy var alertPresenter: AlertPresenter = deferred()
    lazy var taskGroup: TaskGroupDTO = deferred()
    lazy var updateSink: Binder<Void> = deferred()
    lazy var alerts: TaskGroupDetailsAlerts = deferred()

    // MARK: - ModuleViewModel
    struct Input {
        let createItem: Signal<String>
        let updateItemName: Signal<(TaskDTO, String)>
        let switchItemCompleted: Signal<TaskDTO>
        let deleteItem: Signal<TaskDTO>
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

        Signal
            .merge(
                input.updateItemName.map { TaskUpdateParameters(id: $0.0.id, name: $0.1) },
                input.switchItemCompleted.map { TaskUpdateParameters(id: $0.id, isCompleted: !$0.isCompleted) }
            )
            .emit(to: updateItemRelay)
            .disposed(with: disposable)

        updateGroupRelay
            .bind(to: updateSink)
            .disposed(with: disposable)

        return disposable
    }

    // MARK: - Public
    enum TasksState {
        case loading
        case content([TaskDTO])
        case error
    }

    private(set) lazy var isLoading = activityTracker.asDriver()

    private(set) lazy var groupName = Driver.just(taskGroup.name)

    private(set) lazy var tasksState = reloadDataRelay
        .startWith(())
        .flatMapLatest { [weak self] _ -> Observable<TasksState> in
            guard let this = self else {
                return .just(.error)
            }

            let groupAffectingActions = Observable
                .merge(this.createTask, this.updateTask, this.deleteTask)
                .do(onNext: { [weak this] _ in
                    this?.updateGroupRelay.accept(())
                })

            return Observable
                .merge(this.obtainTasks, groupAffectingActions)
                .scan(.loading, accumulator: this.accumulator)
                .startWith(.loading)
                .do(onNext: { [weak this] in
                    if case let .content(tasks) = $0 {
                        this?.tasksCountRelay.accept(tasks.count)
                    } else {
                        this?.tasksCountRelay.accept(0)
                    }
                })
        }
        .asDriver(onError: .never)

    // MARK: - Private
    private let activityTracker = ActivityTracker()
    private let reloadDataRelay = PublishRelay<Void>()
    private let deleteItemRelay = PublishRelay<TaskDTO>()
    private let updateItemRelay = PublishRelay<TaskUpdateParameters>()
    private let createItemRelay = PublishRelay<String>()
    private let tasksCountRelay = BehaviorRelay<Int>(value: 0)
    private let updateGroupRelay = PublishRelay<Void>()

    private lazy var accumulator: (TasksState, Change) throws -> TasksState = { previousState, change in
        switch (change, previousState) {
        case let (.set(state), _):
            return state
        case let (.append(item), .content(tasks)):
            return .content(tasks + [item])
        case let (.update(item), .content(tasks)):
            return .content(tasks.map { $0.id == item.id ? item : $0 })
        case let (.delete(item), .content(tasks)):
            return .content(tasks.filter { $0.id != item.id })
        default:
            return previousState
        }
    }

    private lazy var obtainTasks: Observable<Change> = tasksService.obtainTasks(groupID: taskGroup.id)
        .asObservable()
        .map { .set(.content($0)) }
        .retry(using: errorHandlerProvider)
        .catchErrorJustReturn(.set(.error))

    private lazy var createTask = createItemRelay
        .withLatestFrom(tasksCountRelay) { ($0, $1) }
        .flatMap { [weak self] name, tasksCount -> Observable<Change> in
            guard let this = self else {
                return .empty()
            }

            if tasksCount == 100 {
                return this.alertPresenter
                    .presentStandardAlert(content: this.alerts.limitReachedAlertContent)
                    .asCompletable()
                    .andThen(Observable.empty())
            }

            return this.tasksService.createTask(groupID: this.taskGroup.id, name: name)
                .asObservable()
                .map { .append($0) }
                .retry(using: this.errorHandlerProvider)
                .catchErrorJustComplete()
                .trackActivity(this.activityTracker)
        }

    private lazy var updateTask = updateItemRelay.flatMap { [weak self] parameters -> Observable<Change> in
        guard let this = self else {
            return .empty()
        }
        return this.tasksService.updateTask(id: parameters.id, name: parameters.name, isCompleted: parameters.isCompleted)
            .asObservable()
            .map { .update($0) }
            .retry(using: this.errorHandlerProvider)
            .catchErrorJustComplete()
            .trackActivity(this.activityTracker)
    }

    private lazy var deleteTask = deleteItemRelay.flatMap { [weak self] task -> Observable<Change> in
        guard let this = self else {
            return .empty()
        }
        return this.tasksService.deleteTask(id: task.id)
            .andThen(.just(.delete(task)))
            .retry(using: this.errorHandlerProvider)
            .catchErrorJustComplete()
            .trackActivity(this.activityTracker)
    }

    private lazy var confirmDeletion: (TaskDTO) -> Signal<TaskDTO> = { [weak self] task in
        guard let this = self else {
            return .empty()
        }
        return this.alertPresenter
            .presentStandardAlert(content: this.alerts.deleteItemAlertContent)
            .asObservable()
            .filter { $0 == .yes }
            .map(to: task)
            .asSignal(onError: .never)
    }

    private struct TaskUpdateParameters {
        let id: Int
        let name: String?
        let isCompleted: Bool?

        init(id: Int, name: String? = nil, isCompleted: Bool? = nil) {
            self.id = id
            self.name = name
            self.isCompleted = isCompleted
        }
    }

    private enum Change {
        case set(TasksState)
        case append(TaskDTO)
        case update(TaskDTO)
        case delete(TaskDTO)
    }
}
