//
//  TaskGroupDetailsDependencies.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 29/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

protocol TaskGroupDetailsTasksService {

    func obtainTasks(groupID: Int) -> Single<[TaskDTO]>
    func createTask(groupID: Int, name: String) -> Single<TaskDTO>
    func updateTask(id: Int, name: String?, isCompleted: Bool?) -> Single<TaskDTO>
    func deleteTask(id: Int) -> Completable
}
