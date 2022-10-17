//
//  PlannerDependencies.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 04.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift

protocol PlannerTasksService {

    func obtainTaskGroups() -> Single<[TaskGroupDTO]>
    func createTaskGroup(name: String) -> Single<TaskGroupDTO>
    func updateTaskGroup(id: Int, name: String) -> Single<TaskGroupDTO>
    func deleteTaskGroup(id: Int) -> Completable
}

protocol PlannerUpdateProvider {

    var updateData: Signal<Void> { get }
}
