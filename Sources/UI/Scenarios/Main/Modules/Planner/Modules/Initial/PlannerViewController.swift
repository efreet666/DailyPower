//
//  PlannerViewController.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 04.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class PlannerViewController: UIViewController, ModuleView {

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var newItemTextField: PlannerNewItemTextField!
    @IBOutlet private weak var loadingView: LoadingView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: - ModuleView
    var output: PlannerViewModel.Input {
        return PlannerViewModel.Input(
            createItem: newItemTextField.rx.name,
            updateItem: updateItemRelay.asSignal(),
            deleteItem: deleteItemRelay.asSignal(),
            showItem: tableView.rx.modelSelected(TaskGroupDTO.self).asSignal(),
            reloadData: loadingView.rx.retryTap.asSignal()
        )
    }

    func setupBindings(to viewModel: PlannerViewModel) -> Disposable {
        let taskGroups = viewModel.taskGroupsState.compactMap { state -> [TaskGroupDTO]? in
            guard case let .content(content) = state else {
                return nil
            }
            return content
        }

        let configureCell: (Int, TaskGroupDTO, PlannerItemCell) -> Void = { [updateItemRelay] _, element, cell in
            cell.setup(
                with: .init(
                    title: element.name,
                    isCompleted: element.isCompleted,
                    completedImage: R.image.planner.checkmark(),
                    notCompletedImage: .color(.clear, options: .resizable)
                )
            )
            cell.titleChanged = {
                updateItemRelay.accept((element, $0))
            }
        }

        let cellIdentifier = R.reuseIdentifier.plannerItemCell.identifier

        return Disposables.create(
            viewModel.isLoading
                .drive(activityIndicatorView.rx.isAnimating),
            viewModel.isLoading
                .drive(view.rx.isUserInteractionDisabled),
            viewModel.taskGroupsState
                .map { $0.asLoadingViewMode() }
                .drive(loadingView.rx.mode),
            taskGroups
                .drive(tableView.rx.items(cellIdentifier: cellIdentifier, cellType: PlannerItemCell.self), curriedArgument: configureCell)
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
        navigationItem.title = R.string.localizable.planner_screen_title()

        tableView.register(R.nib.plannerItemCell)

        newItemTextField.attributedPlaceholder = R.string.localizable.planner_screen_new_taskgroup().attributed(with: .placeholder)

        loadingView.loadingText = R.string.localizable.planner_screen_loading()
        loadingView.errorText = R.string.localizable.planner_screen_loading_error()
        loadingView.retryText = R.string.localizable.planner_screen_retry_loading()
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
            // Возможно баг UITableView в iOS13+. После окончания анимации скрытия экшен кнопок у таблицы дергается
            // resignFirstResponder, из-за чего мы получаем две проблемы - мы только что установили фокус на поле
            // ввода и его тут же забирают, и вторая - после исчезновения клавиатуры таблица неадекватно лейаутит
            // ячейку - в результате получаем пустоту вместо ячейки, тычек по которой ведет к крешу. Воркараунд -
            // каким-то образом помогает перезагрузка ячейки.
            tableView.reloadRows(at: [indexPath], with: .none)
        }

        tableView.cellForRow(at: indexPath)?.becomeFirstResponder()
    }

    private func runDeleteAction(forRowAt indexPath: IndexPath) {
        if let taskGroup: TaskGroupDTO = try? tableView.rx.model(at: indexPath) {
            deleteItemRelay.accept(taskGroup)
        }
    }

    private let disposeBag = DisposeBag()
    private let deleteItemRelay = PublishRelay<TaskGroupDTO>()
    private let updateItemRelay = PublishRelay<(TaskGroupDTO, String)>()
}

extension PlannerViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: R.string.localizable.planner_screen_edit()) { [weak self] _, indexPath in
            // На iOS10 экшены не скрываются автоматически, поэтому скрываем вручную
            self?.tableView.setEditing(false, animated: true)
            self?.runEditAction(forRowAt: indexPath)
        }
        edit.backgroundColor = Palette.colors.editButton

        let delete = UITableViewRowAction(style: .normal, title: R.string.localizable.planner_screen_delete()) { [weak self] _, indexPath in
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
            // Необходимо внимательно отнестись к выбору стиля экшена и значения, отдаваемого в коллбэк. Если
            // экшен имеет .destructive стиль и мы отдаем true в коллбэк (говоря таблице, что мы выполнили
            // экшен), то таблица анимирует удаление ячейки, что может быть нежелательным поведением. Большого
            // смысла в указании стиля экшена как .destructive нет, так как цвет фона мы настраиваем сами,
            // а дополнительное поведение таблицы нам не нужно, поэтому используем .normal + true.
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

private extension PlannerViewModel.TaskGroupsState {

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
