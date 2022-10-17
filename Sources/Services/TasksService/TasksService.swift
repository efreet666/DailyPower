//
//  TasksService.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 29/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

final class TasksService {

    // MARK: - Dependencies
    lazy var networkClient: TasksServiceNetworkClient = deferred()

    // MARK: - Public
    func obtainTaskGroups() -> Single<[TaskGroupDTO]> {
        let request = ObtainTaskGroupsNetworkRequest()
        return networkClient.performRequest(request).payload()
    }

    func createTaskGroup(name: String) -> Single<TaskGroupDTO> {
        let request = CreateTaskGroupNetworkRequest(name: name)
        return networkClient.performRequest(request).payload()
    }

    func updateTaskGroup(id: Int, name: String) -> Single<TaskGroupDTO> {
        let request = UpdateTaskGroupNetworkRequest(id: id, name: name)
        return networkClient.performRequest(request).payload()
    }

    func deleteTaskGroup(id: Int) -> Completable {
        let request = DeleteTaskGroupNetworkRequest(id: id)
        return networkClient.performRequest(request)
    }

    func obtainTasks(groupID: Int) -> Single<[TaskDTO]> {
        let request = ObtainTasksNetworkRequest(groupID: groupID)
        return networkClient.performRequest(request).payload()
    }

    func createTask(groupID: Int, name: String) -> Single<TaskDTO> {
        let request = CreateTaskNetworkRequest(groupID: groupID, name: name)
        return networkClient.performRequest(request).payload()
    }

    func updateTask(id: Int, name: String?, isCompleted: Bool?) -> Single<TaskDTO> {
        let request = UpdateTaskNetworkRequest(id: id, name: name, isCompleted: isCompleted)
        return networkClient.performRequest(request).payload()
    }

    func deleteTask(id: Int) -> Completable {
        let request = DeleteTaskNetworkRequest(id: id)
        return networkClient.performRequest(request)
    }

    // MARK: - Private
}
