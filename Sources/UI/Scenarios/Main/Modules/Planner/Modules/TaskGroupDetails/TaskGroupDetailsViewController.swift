//
//  TaskGroupDetailsViewController.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 29/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class TaskGroupDetailsViewController: UIViewController, ModuleView {

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var newItemTextField: PlannerNewItemTextField!
    @IBOutlet private weak var loadingView: LoadingView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: - ModuleView
    var output: TaskGroupDetailsViewModel.Input {
        return TaskGroupDetailsViewModel.Input(
            createItem: newItemTextField.rx.name,
            updateItemName: updateItemNameRelay.asSignal(),
            switchItemCompleted: tableView.rx.modelSelected(TaskDTO.self).asSignal(),
            deleteItem: deleteItemRelay.asSignal(),
            reloadData: loadingView.rx.retryTap.asSignal()
        )
    }

    func setupBindings(to viewModel: TaskGroupDetailsViewModel) -> Disposable {
        let tasks = viewModel.tasksState.compactMap { state -> [TaskDTO]? in
            guard case let .content(content) = state else {
                return nil
            }
            return content
        }

        let configureCell: (Int, TaskDTO, PlannerItemCell) -> Void = { [updateItemNameRelay] _, element, cell in
            cell.setup(
                with: .init(
                    title: element.name,
                    isCompleted: element.isCompleted,
                    completedImage: R.image.common.checkbox_on(),
                    notCompletedImage: R.image.common.checkbox_off()
                )
            )
            cell.titleChanged = {
                updateItemNameRelay.accept((element, $0))
            }
        }

        let cellIdentifier = R.reuseIdentifier.plannerItemCell.identifier

        return Disposables.create(
            viewModel.isLoading
                .drive(activityIndicatorView.rx.isAnimating),
            viewModel.isLoading
                .drive(view.rx.isUserInteractionDisabled),
            viewModel.tasksState
                .map { $0.asLoadingViewMode() }
                .drive(loadingView.rx.mode),
            tasks
                .drive(tableView.rx.items(cellIdentifier: cellIdentifier, cellType: PlannerItemCell.self), curriedArgument: configureCell),
            viewModel.groupName
                .drive(navigationItem.rx.title)
        )
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupInternalBindings()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    // MARK: - Private
    private func setupUI() {
        tableView.register(R.nib.plannerItemCell)

        newItemTextField.attributedPlaceholder = R.string.localizable.taskgroup_screen_new_task().attributed(with: .placeholder)

        loadingView.loadingText = R.string.localizable.taskgroup_screen_loading()
        loadingView.errorText = R.string.localizable.taskgroup_screen_loading_error()
        loadingView.retryText = R.string.localizable.taskgroup_screen_retry_loading()
    }

    private func setupInternalBindings() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillChangeFrameNotification)
            .compactMap { [weak self] notification -> UIEdgeInsets? in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                    return nil
                }
                guard let scrollViewFrame = self.map({ $0.tableView.convert($0.tableView.bounds, to: nil) }) else {
                    return nil
                }
                return UIEdgeInsets(top: 0, left: 0, bottom: scrollViewFrame.intersection(keyboardFrame).height, right: 0)
            }
            .bind(to: tableView.rx.contentInset)
            .disposed(by: disposeBag)

        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    private func runEditAction(forRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            tableView.reloadRows(at: [indexPath], with: .none)
        }

        tableView.cellForRow(at: indexPath)?.becomeFirstResponder()
    }

    private func runDeleteAction(forRowAt indexPath: IndexPath) {
        if let task: TaskDTO = try? tableView.rx.model(at: indexPath) {
            deleteItemRelay.accept(task)
        }
    }

    private let disposeBag = DisposeBag()
    private let deleteItemRelay = PublishRelay<TaskDTO>()
    private let updateItemNameRelay = PublishRelay<(TaskDTO, String)>()
}

extension TaskGroupDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: R.string.localizable.taskgroup_screen_edit()) { [weak self] _, indexPath in
            self?.tableView.setEditing(false, animated: true)
            self?.runEditAction(forRowAt: indexPath)
        }
        edit.backgroundColor = Palette.colors.editButton

        let delete = UITableViewRowAction(style: .normal, title: R.string.localizable.taskgroup_screen_delete()) { [weak self] _, indexPath in
            self?.tableView.setEditing(false, animated: true)
            self?.runDeleteAction(forRowAt: indexPath)
        }
        delete.backgroundColor = Palette.colors.deleteButton

        return [delete, edit]
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, callback in
            self?.runEditAction(forRowAt: indexPath)
            callback(true)
        }
        edit.backgroundColor = Palette.colors.editButton
        edit.image = R.image.planner.edit_action()

        let delete = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, callback in
            self?.runDeleteAction(forRowAt: indexPath)
            callback(true)
        }
        delete.backgroundColor = Palette.colors.deleteButton
        delete.image = R.image.planner.delete_action()

        return with(UISwipeActionsConfiguration(actions: [delete, edit])) {
            $0.performsFirstActionWithFullSwipe = false
        }
    }
}

private extension TextAttributes {

    static let placeholder = TextAttributes()
        .font(Palette.fonts.style1)
        .textColor(Palette.colors.subtitle)
}

private extension TaskGroupDetailsViewModel.TasksState {

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
