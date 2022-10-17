//
//  TasksServiceDependenciesExtensions.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 29/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

struct TasksServiceDefaultNetworkClient: TasksServiceNetworkClient {

    let performer: NetworkRequestPerformer

    func performRequest(_ request: ObtainTaskGroupsNetworkRequest) -> Single<TaskGroupsNetworkResponse> {
        return performer.performRequest(request)
    }

    func performRequest(_ request: CreateTaskGroupNetworkRequest) -> Single<TaskGroupNetworkResponse> {
        return performer.performRequest(request)
    }

    func performRequest(_ request: UpdateTaskGroupNetworkRequest) -> Single<TaskGroupNetworkResponse> {
        return performer.performRequest(request)
    }

    func performRequest(_ request: DeleteTaskGroupNetworkRequest) -> Completable {
        return performer.performRequestWithEmptyResponse(request)
    }

    func performRequest(_ request: ObtainTasksNetworkRequest) -> Single<TasksNetworkResponse> {
        return performer.performRequest(request)
    }

    func performRequest(_ request: CreateTaskNetworkRequest) -> Single<TaskNetworkResponse> {
        return performer.performRequest(request)
    }

    func performRequest(_ request: UpdateTaskNetworkRequest) -> Single<TaskNetworkResponse> {
        return performer.performRequest(request)
    }

    func performRequest(_ request: DeleteTaskNetworkRequest) -> Completable {
        return performer.performRequestWithEmptyResponse(request)
    }
}
