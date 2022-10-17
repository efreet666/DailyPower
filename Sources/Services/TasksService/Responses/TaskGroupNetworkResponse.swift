//
//  TaskGroupNetworkResponse.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 26/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

typealias TaskGroupNetworkResponse = DecodableNetworkResponse<TaskGroupDTO>

struct TaskGroupDTO: Codable {

    let id: Int
    let name: String
    let isCompleted: Bool
}
