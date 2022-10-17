//
//  NetworkClient.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 08.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation
import RxSwift

final class NetworkClient {

    // MARK: - Dependencies
    lazy var taskFactory: NetworkClientTaskFactory = deferred()
    lazy var responseMapper: NetworkClientResponseMapper = deferred()

    // MARK: - Public
    func performRequest<ResponseType: NetworkResponse>(_ request: NetworkRequest) -> Single<ResponseType> {
        return taskFactory.task(for: request)
            .flatMap(taskResult(for: request))
            .subscribeOn(scheduler)
    }

    // MARK: - Private
    private func taskResult<ResponseType: NetworkResponse>(for request: NetworkRequest) -> (NetworkTask) throws -> Single<ResponseType> {
        return { originalTask in
            return Single<ResponseType>.create { singleEvent in
                let handler: NetworkResponseCompletion = { data, error, timeline in
                    let mapperInput = NetworkResponseMapperInput(data: data, error: error, request: request, timeline: timeline)
                    let mappedResponse: NetworkResponseMapperOutput<ResponseType> = self.responseMapper.map(input: mapperInput)

                    switch mappedResponse {
                    case let .error(responseError):
                        singleEvent(.error(responseError))
                    case let .success(responseValue):
                        singleEvent(.success(responseValue))
                    }
                }

                let task: NetworkTask

                switch ResponseType.dataType {
                case .empty:
                    task = originalTask.responseEmpty(queue: self.responseQueue, completionHandler: handler)
                case .json:
                    task = originalTask.responseJSON(queue: self.responseQueue, completionHandler: handler)
                case .data:
                    task = originalTask.responseData(queue: self.responseQueue, completionHandler: handler)
                }

                task.resume()

                return Disposables.create {
                    task.cancel()
                }
            }
        }
    }

    private let scheduler = SerialDispatchQueueScheduler(qos: .background)
    private let responseQueue = DispatchQueue(label: "network.client.response.queue", qos: .background, attributes: .concurrent)
}

extension NetworkClient: NetworkRequestPerformer {
}
