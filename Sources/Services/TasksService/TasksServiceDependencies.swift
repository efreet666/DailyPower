//
//  TasksServiceDependencies.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 29/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

protocol TasksServiceNetworkClient {

    func performRequest(_ request: ObtainTaskGroupsNetworkRequest) -> Single<TaskGroupsNetworkResponse>
    func performRequest(_ request: CreateTaskGroupNetworkRequest) -> Single<TaskGroupNetworkResponse>
    func performRequest(_ request: UpdateTaskGroupNetworkRequest) -> Single<TaskGroupNetworkResponse>
    func performRequest(_ request: DeleteTaskGroupNetworkRequest) -> Completable

    func performRequest(_ request: ObtainTasksNetworkRequest) -> Single<TasksNetworkResponse>
    func performRequest(_ request: CreateTaskNetworkRequest) -> Single<TaskNetworkResponse>
    func performRequest(_ request: UpdateTaskNetworkRequest) -> Single<TaskNetworkResponse>
    func performRequest(_ request: DeleteTaskNetworkRequest) -> Completable
}
