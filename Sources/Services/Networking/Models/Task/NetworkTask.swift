//
//  NetworkTask.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 08.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

typealias NetworkResponseCompletion = (_ data: Any?, _ error: Error?, _ timeline: NetworkRequestTimeline) -> Void

protocol NetworkTask {

    func resume()
    func suspend()
    func cancel()

    func responseJSON(queue: DispatchQueue, completionHandler: @escaping NetworkResponseCompletion) -> Self
    func responseEmpty(queue: DispatchQueue, completionHandler: @escaping NetworkResponseCompletion) -> Self
    func responseData(queue: DispatchQueue, completionHandler: @escaping NetworkResponseCompletion) -> Self
}
