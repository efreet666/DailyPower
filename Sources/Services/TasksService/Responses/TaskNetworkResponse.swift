//
//  TaskNetworkResponse.swift
//  DailyPower
//
//  Created by Vitaliy Zagorodnov on 29/03/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

typealias TaskNetworkResponse = DecodableNetworkResponse<TaskDTO>

struct TaskDTO: Codable {

    let id: Int
    let name: String
    let isCompleted: Bool
}
